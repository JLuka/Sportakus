//
//  DurchfuehrungInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import HealthKit

class DurchfuehrungInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {

    @IBOutlet var uebungsNameLabel: WKInterfaceLabel!
    @IBOutlet var gewichtLabel: WKInterfaceLabel!
    @IBOutlet var wiederholungenLabel: WKInterfaceButton!
    @IBOutlet var saetzeWortLabel: WKInterfaceLabel!
    @IBOutlet var saetzeLabel: WKInterfaceLabel!
    
    //Uebergebene Werte
    var uebung = [String]()
    var uebungsName = String()
    var gewicht = Int()
    var zuErreichendeSaetze = Int()
    var zuErreichendeWiederholungen = Int()
    
    //Variable Werte
    var wiederholung = 0
    var satz = 0
    
    //Timer
    var countDownToStartExercise = Timer()
    var neededTime = Timer()
    var timeCounter = 5
    var time = 0
    
    //Motion Handler
    var motionManager = CMMotionManager()
    
    //let healthStore: HKHealthStore = HKHealthStore()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        uebung = context as! [String]
        fillViewWithContent()
        
//        let configuration = HKWorkoutConfiguration()
//        
//        configuration.activityType = .traditionalStrengthTraining
//        configuration.locationType = .indoor
//        
//        do {
//            
//            let session = try HKWorkoutSession(configuration: configuration)
//            session.delegate = self
//            healthStore.start(session)
//            print("Läuft")
//        }
//        catch let error as NSError {
//            // Perform proper error handling here...
//            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
//        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        motionManager.stopDeviceMotionUpdates()
    }

    //Die View mit der übergebenen Übung füllen
    func fillViewWithContent(){
        uebungsName = uebung[0]
        gewicht = Int(uebung[1])!
        zuErreichendeSaetze = Int(uebung[2])!
        zuErreichendeWiederholungen = Int(uebung[3])!
        
        uebungsNameLabel.setText(uebungsName)
        if gewicht == 0 {
            gewichtLabel.setText("EG")
        }else{
            gewichtLabel.setText(String(gewicht) + "kg")
        }
        
        wiederholungenLabel.setTitle(String(zuErreichendeWiederholungen))
        saetzeLabel.setText(String(zuErreichendeSaetze))
    }

    @IBAction func startButtonPressed() {
        wiederholungenLabel.setTitle("Bereit?")
        countDownToStartExercise.invalidate()
        
        if timeCounter > 2 {
            countDownToStartExercise = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            wiederholungenLabel.setEnabled(false)
            satz += 1
        }
    }
    
    func timerAction() {
        if timeCounter > 0 {
            timeCounter -= 1
            if timeCounter == 4 {
                wiederholungenLabel.setTitle("Start in:")
            }else if timeCounter == 0{
                wiederholungenLabel.setTitle("Los")
            }else {
                wiederholungenLabel.setTitle("\(timeCounter)")
            }
            
            saetzeLabel.setText("\(satz)")
            saetzeWortLabel.setText("Satz")
        }else{
            countDownToStartExercise.invalidate()
            WKInterfaceDevice.current().play(.click)
            countRepititions()
        }
    }
    
    func countRepititions(){
        wiederholungenLabel.setEnabled(true)
        timerStarten()
        if uebungsName == "Hammer-Curls" {
            countRepsForHammerCurls()
        }
    }
    
    
    
    @IBAction func stopButtonPressed() {
        wiederholung += 1
        if wiederholung == zuErreichendeWiederholungen {
            zielErreicht()
        }
    }

    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
