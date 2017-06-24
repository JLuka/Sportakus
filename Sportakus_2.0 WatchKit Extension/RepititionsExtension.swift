//
//  RepititionsExtension.swift
//  Sportakus_2.0
//
//  Created by Emel Altmisoglu on 24.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

extension DurchfuehrungInterfaceController {
    
    //Starten der DeviceMotion Updates 
    //Alle 0.1 Sekunden wird der UpdateHandler dafür aufgerufen
    func countReps(){
        motionManager.startDeviceMotionUpdates()
        motionManager.deviceMotionUpdateInterval = 0.1
        if motionManager.isDeviceMotionAvailable{
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (motion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(motion: motion!)
                    } else {
                        //handle the error
                    }
            })
        }
    }
    
    //Logik der Updates von DeviceMotion im vorgegebenen Intervall
    func handleDeviceMotionUpdate(motion:CMDeviceMotion) {
        self.startLabel.setEnabled(true)
        
        //Je nach Übung die entsprechende logik ausführen
        if(self.uebungsName == "Hammer-Curls"){
            checkHammerCurlsRep(motion: motion)
        }
        else if(self.uebungsName == "Bizeps-Curls"){
            checkBizepsCurlsRep(motion: motion)
        }
        else if(self.uebungsName == "Butterfly"){
            checkButterflyRep(motion: motion)
        }
        else if(self.uebungsName == "Crunches"){
            checkCrunchesRep(motion: motion)
        }
        else{
            //Bei nicht vorgefertigter Übungslogik, jede andere Übung Zeitbasierend starten
            checkTimeBasedRep()
        }
       
    }
    
    
    //Methode um einen Radianten in Grad umzurechnen
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    //Wenn eine Wiederholung abgeschlossen ist Variable hochzählen
    //Wenn die zuvor gesetzen Wiederholungen erreicht sind alle Werte zurücksetzen
    //und Updates zu DeviceMotion stoppen
    func repitionDone(){
        self.increaseReps()
        self.startLabel.setTitle("\(self.wiederholung)")
        
        if self.wiederholung == self.zuErreichendeWiederholungen {
            self.zielErreicht()
            self.started = false
            self.repTimerCounter = 0
            self.repTimer.invalidate()
            self.motionManager.stopDeviceMotionUpdates()
            WKInterfaceDevice.current().play(.notification)
            WKInterfaceDevice.current().play(.success)
        }
    }
    
    
    //Methode um Wiederholungen von Hammer-Curls zu zählen
    func checkHammerCurlsRep(motion:CMDeviceMotion){
        
        //gravity werte runden und erweitern, für einfachere Les- und Prüfbarkeit
        let gravity_x = round(motion.gravity.x)*100
        let gravity_z = round(motion.gravity.z)*100
        
        //Prüfen ob der Arm nach oben gerichtet ist
        if(gravity_x < -99 && gravity_z == -0){
            self.lifted = true
        }
        
        //Prüfen ob Arm wieder nach unten gerichtet ist,
        //Wiederholung abgeschlossen wenn Handgelenk richtig ausgerichtet ist
        //z muss -0 sein und x = 100
        //** Z prüft ob Arm oben oder unten ist, X prüft die Richtung des Handgelenks
        //WIEDERHOLUNG WIRD NUR GEZÄHLT WENN DER ARM ZUVOR NACH OBEN GERICHTET WURDE
        if(!self.lifted){
            return
        }
        else if(gravity_z != -0){
            return
        }
        else if(gravity_x > 99){
            self.lifted = false
            repitionDone();
        }
    }
    
    //Methode um Wiederholungen von Bizeps-Curls zu zählen
    //Ähnlich der Hammer-Curls Methode mit inversen Werten
    func checkBizepsCurlsRep(motion:CMDeviceMotion){
        //gravity werte runden und erweitern, für einfachere Les- und Prüfbarkeit
        let gravity_x = round(motion.gravity.x)*100
        let gravity_z = round(motion.gravity.z)*100
        
        //Prüfen ob der Arm nach oben gerichtet ist
        if(gravity_x < -99 && gravity_z == 0){
            self.lifted = true
        }
        
        //Prüfen ob Arm wieder nach unten gerichtet ist,
        //Wiederholung abgeschlossen wenn Handgelenk richtig ausgerichtet ist
        //z muss 0 sein und x = 100
        //** Z prüft ob Arm oben oder unten ist, X prüft die Richtung des Handgelenks
        //WIEDERHOLUNG WIRD NUR GEZÄHLT WENN DER ARM ZUVOR NACH OBEN GERICHTET WURDE
        if(!self.lifted){
            return
        }
        else if(gravity_z != 0){
            return
        }
        else if(gravity_x > 99){
            self.lifted = false
            repitionDone();
        }
    }
    
    
    //Methode um Wiederholungen von Butterfly zu zählen
    func checkButterflyRep(motion:CMDeviceMotion){
        //Werte runden und erweitern, für einfachere Les- und Prüfbarkeit
        //für mehr genauigkeit wird Rotationsrate nach y geneuer gerundet und dann erweitert
        let gravity_y = round(motion.gravity.y)*100
        let rotRate_y = round(motion.rotationRate.y*1000)/10
        
        
        //Prüfen ob Arm wieder nach unten gerichtet ist,
        //Wiederholung abgeschlossen wenn Handgelenk richtig ausgerichtet ist
        //** gravity_y prüft ob der Arm richtig positioniert ist, 
        //rotRate_y prüft ob der Arm von aussen nach innen bewegt wurde
        //WIEDERHOLUNG WIRD NUR GEZÄHLT WENN DER ARM ZUVOR NACH INNEN GERICHTET WURDE
        if(gravity_y > 99 && rotRate_y > 70){
            self.lifted = true
        }
        
        if(!self.lifted){
            return
        }
        else if(gravity_y > 99 && rotRate_y < -70){
            self.lifted = false;
            repitionDone();
        }
    }
    
    //Methode um Wiederholungen von Butterfly zu zählen
    //Dasselbe wie Butterfly mit inversen Werten
    func checkButterflyReverseRep(motion:CMDeviceMotion){
        //Werte runden und erweitern, für einfachere Les- und Prüfbarkeit
        //für mehr genauigkeit wird Rotationsrate nach y geneuer gerundet und dann erweitert
        let gravity_y = round(motion.gravity.y)*100
        let rotRate_y = round(motion.rotationRate.y*1000)/10
        
        //Prüfen ob Arm wieder nach unten gerichtet ist,
        //Wiederholung abgeschlossen wenn Handgelenk richtig ausgerichtet ist
        //** gravity_y prüft ob der Arm richtig positioniert ist,
        //rotRate_y prüft ob der Arm von aussen nach innen bewegt wurde
        //WIEDERHOLUNG WIRD NUR GEZÄHLT WENN DER ARM ZUVOR NACH INNEN GERICHTET WURDE
        if(gravity_y < -99 && rotRate_y < -70){
            self.lifted = true
        }
        
        if(!self.lifted){
            return
        }
        else if(gravity_y < -99 && rotRate_y > 70){
            self.lifted = false;
            repitionDone();
        }
    }
    
    //Methode um Wiederholungen von Crunches zu zählen
    func checkCrunchesRep(motion:CMDeviceMotion){
        //Werte runden und erweitern, für einfachere Les- und Prüfbarkeit
        //für mehr genauigkeit wird Rotationsrate nach x geneuer gerundet und dann erweitert
        //Da bei Crunches der Körper nicht vollständig auf 90 Grad gebeugt wird, 
        //wird auf einen kleineren Zwischenwert geprüft
        let rotRate_x = round(motion.rotationRate.x*1000)/10
        let gravity_z = round(motion.gravity.z)*100
        
        print("gravity_X\(round(motion.gravity.x*1000)/10)")
        print("rot_x\(round(motion.rotationRate.x*1000)/10)")
        
        if(rotRate_x < 10 && gravity_z < 1){
            self.lifted = true;
        }
        
        if(!self.lifted){
            return
        }
        else if(rotRate_x > 10 && gravity_z < -99 ){
            self.lifted = false;
            repitionDone();
        }
        
    }
    
    //Für alle nicht definierten Übungen, die Wiederholunden Zeitbasiert steuern
    func checkTimeBasedRep(){
        if(!self.started){
            repTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(repReminder), userInfo: nil, repeats: true)
            self.started = true
        }
    }
    
    //Timer update für Zeitbasierte Übung
    func repReminder(){
        //Halbe Wiederholung
        if(repTimerCounter % 2 == 1){
            WKInterfaceDevice.current().play(.start)
        }
        //Wiederholung abgeschlossen
        else{
            WKInterfaceDevice.current().play(.stop)
            repitionDone()
        }
        repTimerCounter += 1;
    }
}
