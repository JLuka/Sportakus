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
    var lifted = false
    var repTimerCounter = 0;
    var started = false;
    
    //Timer
    var countDownToStartExercise = Timer()
    var neededTime = Timer()
    var repTimer = Timer()
    var timeCounter = 5
    var time = 0
    
    //Zustand des Views
    var isActivated = false;
    
    //Motion Handler
    var motionManager = CMMotionManager()
    
    var viewContentWurdeSchonGeladen = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        uebung = context as! [String]
        
    }
    
    override func willActivate() {
        super.willActivate()
        if viewContentWurdeSchonGeladen == false{
            fillViewWithContent()
        }
        self.isActivated = true;
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        self.isActivated = false;
        //motionManager.stopDeviceMotionUpdates()
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
        viewContentWurdeSchonGeladen = true
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
                startLabel.setTitle(String(wiederholung))
            }else {
                startLabel.setTitle("\(timeCounter)")
            }
            saetzeLabel.setText("\(satz)")
            
        }else{
            countDownToStartExercise.invalidate()
            WKInterfaceDevice.current().play(.start)
            WKInterfaceDevice.current().play(.notification)
            timeCounterReset()
            countRepititions()
        }
    }
    
    func countRepititions(){
        timerStarten()
        
        countReps()
        
    }
    
    func increaseReps(){
        self.wiederholung += 1
        if wiederholung > 0 {
            stopButton.setEnabled(true)
        }
    }
    
    func timeCounterReset(){
        self.timeCounter = 5;
    }
    
    @IBAction func stopButtonPressed() {
        zielErreicht()
        motionManager.stopDeviceMotionUpdates()
        WKInterfaceDevice.current().play(.failure)
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
