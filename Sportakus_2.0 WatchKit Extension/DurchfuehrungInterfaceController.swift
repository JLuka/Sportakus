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
    @IBOutlet var saetzeLabel: WKInterfaceLabel!
    @IBOutlet var startLabel: WKInterfaceButton!
    @IBOutlet var wiederholungenLabel: WKInterfaceLabel!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    //Uebergebene Werte
    var uebung = [String]()
    var uebungsName = String()
    var gewicht = Double()
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
        gewicht = Double(uebung[1])!
        zuErreichendeSaetze = Int(uebung[2])!
        zuErreichendeWiederholungen = Int(uebung[3])!
        
        
        uebungsNameLabel.setText(uebungsName)
        stopButton.setEnabled(false)
        
        if gewicht == 0 {
            gewichtLabel.setText("EG")
        }else{
            gewichtLabel.setText(String(gewicht) + "kg")
        }
        satz += 1
        startLabel.setTitle("Start")
        saetzeLabel.setText(String(satz))
        wiederholungenLabel.setText(String(zuErreichendeWiederholungen))
    }

    @IBAction func startButtonPressed() {
        startLabel.setTitle("Bereit?")
        countDownToStartExercise.invalidate()
        startLabel.setEnabled(false)
        if timeCounter > 2 {
            countDownToStartExercise = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            startLabel.setEnabled(false)
        }
    }
    
    func timerAction() {
        if timeCounter > 0 {
            timeCounter -= 1
            if timeCounter == 4 {
                startLabel.setTitle("Start in:")
            }else if timeCounter == 0{
                startLabel.setTitle("Los")
            }else {
                startLabel.setTitle("\(timeCounter)")
            }
            
            saetzeLabel.setText("\(satz)")
        }else{
            countDownToStartExercise.invalidate()
            WKInterfaceDevice.current().play(.click)
            countRepititions()
        }
    }
    
    func countRepititions(){
        timerStarten()
        if uebungsName == "Hammer-Curls" {
            countRepsForHammerCurls()
        }
    }
    
    func increaseReps(){
        self.wiederholung += 1
        if wiederholung > 0 {
            stopButton.setEnabled(true)
        }
    }
    
    
    
    @IBAction func stopButtonPressed() {
        zielErreicht()
    }

    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    
    @IBAction func testButtonPressed() {
        increaseReps()
        startLabel.setTitle(String(wiederholung))
        if wiederholung == zuErreichendeWiederholungen {
            zielErreicht()
        }
    }


}
