//
//  HealthManager.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 24.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager: NSObject, HKWorkoutSessionDelegate {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    var session : HKWorkoutSession?
    var workoutActive = false
    var currentQuery : HKQuery?
    let configuration = HKWorkoutConfiguration()
    var startDateSaved = Date()
    var endDateSaved = Date()
    
    //Authorisieren der Healthkit Informationen
    func authorizeHealthKit(completion: ((_ success:Bool, _ error: Error) -> Void)!){
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set([
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
            ])
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set([
            HKQuantityType.workoutType()
            ])
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable(){
            print("HealthkitData is not available")
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            if success == false {
                print("Authorization failed")
            }
        }
    }

    func startWorkout(){
        if (self.workoutActive) {
            //finish the current workout
            self.workoutActive = false
            if let workout = self.session {
                healthKitStore.end(workout)
            }
        } else {
            //start a new workout
            self.workoutActive = true
            workoutConfiguration()
        }
    }
    
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
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
    }
    
    
    func createWorkoutStreamingQuery() {
        
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            fatalError("*** Unable to create the active energy burned type ***")
        }
        
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            fatalError("Unable to create the active energy burned type")
        }
        
        let device = HKDevice.local()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: session?.startDate, end: session?.endDate, options: [])
        let devicePredicate = HKQuery.predicateForObjects(from: [device])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let sortByDate = NSSortDescriptor(key:HKSampleSortIdentifierStartDate , ascending: true)
        
        let healthStore = self.healthKitStore
        
        let query = HKSampleQuery(sampleType: activeEnergyType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) { (query, returnedSamples, error) -> Void in
            
            guard let samples = returnedSamples as? [HKQuantitySample] else {
                // Add proper error handling here...
                print("*** an error occurred: \(error?.localizedDescription) ***")
                return
            }
            
            let energyUnit = HKUnit.kilocalorie()
            var totalActiveEnergy : Double = 0.0
        
            
            for sample in samples {
                totalActiveEnergy += sample.quantity.doubleValue(for: energyUnit)
            }
            
            let startDate = self.startDateSaved
            let endDate = self.endDateSaved
            let duration = endDate.timeIntervalSince(startDate)
            
            let totalActiveEnergyQuantity = HKQuantity(unit: energyUnit, doubleValue: totalActiveEnergy)
            
            let workout = HKWorkout(activityType: self.configuration.activityType,
                                    start: startDate as Date,
                                    end: endDate as Date,
                                    duration: duration,
                                    totalEnergyBurned: totalActiveEnergyQuantity,
                                    totalDistance: nil,
                                    device: HKDevice.local(),
                                    metadata: [HKMetadataKeyIndoorWorkout : true])
            
            
            self.healthKitStore.save(workout, withCompletion: { (success, error) -> Void in
                guard success else {
                    // Add proper error handling here...
                    print("*** an error occurred: \(error?.localizedDescription) ***")
                    return
                }
                
                self.healthKitStore.add(samples, to: workout, completion: { (success, error) -> Void in
                    guard success else {
                        // Add proper error handling here...
                        print("*** an error occurred: \(error?.localizedDescription) ***")
                        return
                    }
                    
                    print("Workout saved successfully")
                    
                })
                
            })
        }
        
        healthStore.execute(query)
        
    }
    
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            startDateSaved = (session?.startDate)!
            print(startDateSaved)
        case .ended:
            endDateSaved = (session?.endDate)!
            createWorkoutStreamingQuery()
            print("ended")
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    
    
    
}
