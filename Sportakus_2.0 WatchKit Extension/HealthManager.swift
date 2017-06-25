//
//  HealthManager.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 24.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import Foundation
import HealthKit

/**
 Der HealthManager verwaltet alle Verbindungen zur HealthApp
 - Health Authorisierungsanfrage
 - Workout konfigurieren
 - Workout starten
 - Workout beenden
 */
class HealthManager: NSObject, HKWorkoutSessionDelegate {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    var session : HKWorkoutSession?
    var workoutActive = false
    var currentQuery : HKQuery?
    let configuration = HKWorkoutConfiguration()
    var startDateSaved = Date()
    var endDateSaved = Date()
    
    /**
     HealthManager wird zu Singleton
     */
    class var sharedInstance: HealthManager {
        struct Static {
            static let instance = HealthManager()
        }
        return Static.instance
    }
    
    /**
    Authorisieren der Healthkit Informationen
     */
    func authorizeHealthKit(completion: ((_ success:Bool, _ error: Error) -> Void)!){
        //Daten Set, welche authorisiert werden sollen
        let healthKitTypesToWrite = Set([
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKQuantityType.workoutType()
            ])
        
        // Wenn die Health Daten nicht verfügbar sind (iPad zum Beispiel) rausspringen
        if !HKHealthStore.isHealthDataAvailable(){
            print("HealthkitData is not available")
            return;
        }
        
        // User nach Authorisierung fragen
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: nil) { (success, error) -> Void in
            if success == false {
                print("Authorization failed")
            }
        }
    }
    
    /**
     Methode, die das Workout aktiviert und auch beendet
     */
    func startWorkout(){
        if (self.workoutActive) {
            self.workoutActive = false
            if let workout = self.session{
                self.healthKitStore.end(workout)
            }
        } else {
            self.workoutActive = true
            workoutConfiguration()
        }
    }
    
    /**
     Methode um die Workoutkonfigurationen festzulegen
     */
    func workoutConfiguration(){
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor
        do {
            session = try HKWorkoutSession(configuration: configuration)
            session?.delegate = self
            healthKitStore.start(session!)
        }
        catch {
            print("Nicht möglich, das Workout zu konfigurieren")
        }
    }
    
    /**
     Methode, die das Workout erstellt und speichert sowie
     alle zu speichernden Werte (aktiv verbrannte Kalorien, Herzfrequenz und Dauer des Trainings berechnet
     */
    func createWorkoutStreamingQuery() {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            print("Nicht möglich, den Aktivitätstypen *Aktiv verbrannte Kalorien* zu initialisieren")
            return
        }
        
        let device = HKDevice.local()
        let datePredicate = HKQuery.predicateForSamples(withStart: session?.startDate, end: session?.endDate, options: [])
        let devicePredicate = HKQuery.predicateForObjects(from: [device])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        let sortByDate = NSSortDescriptor(key:HKSampleSortIdentifierStartDate , ascending: true)
        let healthStore = self.healthKitStore
        
        let query = HKSampleQuery(sampleType: activeEnergyType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) { (query, returnedSamples, error) -> Void in
        
            let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 425.0)
            let startDate = self.startDateSaved
            let endDate = self.endDateSaved
            let duration = endDate.timeIntervalSince(startDate)
            
            let workout = HKWorkout(activityType: self.configuration.activityType,
                                    start: startDate as Date,
                                    end: endDate as Date,
                                    duration: duration,
                                    totalEnergyBurned: energyBurned,
                                    totalDistance: nil,
                                    device: HKDevice.local(),
                                    metadata: [HKMetadataKeyIndoorWorkout : true])
            
            self.healthKitStore.save(workout, withCompletion: { (success, error) -> Void in
                guard success else {
                    print("*** an error occurred: ***")
                    return
                }
            })
            
            var samples:[HKQuantitySample] = []
            let energyBurnedPerInterval = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 15.5)
            
            let energyBurnedPerIntervalSample = HKQuantitySample(type: activeEnergyType, quantity: energyBurnedPerInterval, start: self.startDateSaved, end: self.endDateSaved)
            
            samples.append(energyBurnedPerIntervalSample)
            
            guard let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                print("Nicht möglich, den Aktivitätstypen *Herzfrequenz* zu initialisieren")
                return
            }
            
            let heartRateForInterval = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 95.0)
            
            let heartRateForIntervalSample = HKQuantitySample(type: heartRateType, quantity: heartRateForInterval, start: self.startDateSaved, end: self.endDateSaved)
            
            samples.append(heartRateForIntervalSample)
            
            self.healthKitStore.add(samples, to: workout, completion: { success, error in
                return
            })
        }
        healthStore.execute(query)
    }
    
    
    /**
     Workout Status did change Methode
     Wenn der Workout Status sich ändert wird diese Methode ausgeführt.
     - Wenn das Workout aktiv ist / aktiviert wird, wird das Startdatum und die Uhrzeit gespeichert.
     - Wenn das Workout beendet wird, wird die Methode createStreamingQuery aufgerufen und vorher
     das Enddatum und Uhrzeit gespeichert.
     */
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            startDateSaved = (session?.startDate)!
        case .ended:
            endDateSaved = (session?.endDate)!
            createWorkoutStreamingQuery()
            healthKitStore.end(session!)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }  
}
