//
//  HammerCurlsExtension.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

extension DurchfuehrungInterfaceController {
    
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
        //Je nach übung die entsprechende logik ausführen
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
            checkTimeBasedRep()
        }
        
        let quat = motion.attitude.quaternion
        let x = quat.x
        let y = quat.y
        let z = quat.z
        let w = quat.w
        
        let roll  = self.degrees(radians: atan2(2*y*w + 2*x*z, 1 - 2*y*y - 2*z*z))
        let pitch = self.degrees(radians: atan2(2*x*w + 2*y*z, 1 - 2*x*x - 2*z*z))
        let yaw   = self.degrees(radians: asin(2*x*y + 2*z*w))
        
       /* let gravity_x = round(motion.gravity.x)*100
        let gravity_y = round(motion.gravity.y)*100
        let gravity_z = round(motion.gravity.z)*100
        
        let rotRate_x = round(motion.rotationRate.x*1000)/10
        let rotRate_y = round(motion.rotationRate.y*1000)/10
        let rotRate_z = round(motion.rotationRate.z*1000)/10
        */
        
        print("acc_x: \(round(motion.userAcceleration.x*1000)/10)")
        print("acc_y: \(round(motion.userAcceleration.y*1000)/10)")
        print("acc_z: \(round(motion.userAcceleration.z*1000)/10)")
        print("grav_x: \(round(motion.gravity.x*1000)/10)")
        print("grav_y: \(round(motion.gravity.y*1000)/10)")
        print("grav_z: \(round(motion.gravity.z*1000)/10)")
        print("rotRate_x: \(round(motion.rotationRate.x*1000)/10)")
        print("rotRate_y: \(round(motion.rotationRate.y*1000)/10)")
        print("rotRate_z: \(round(motion.rotationRate.z*1000)/10)")
        print("pitch: \(round(pitch*1000)/1000)")
        print("roll: \(round(roll*1000)/1000)")
        print("yaw: \(round(yaw*1000)/1000)")
        print("Anzahl: \(self.wiederholung)")
        print("\n\n")
        
        //END TODO
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    //
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
    
    func checkHammerCurlsRep(motion:CMDeviceMotion){
        let gravity_x = round(motion.gravity.x)*100
        let gravity_z = round(motion.gravity.z)*100
        
        if(gravity_x < -99 && gravity_z == -0){
            self.lifted = true            
        }
        
        //Arm ist wieder nach unten gerichtet,
        //Wiederholung abgeschlossen wenn handgelenk richtig ausgerichtet ist
        //z muss -0 sein und x = 100
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
    
    func checkBizepsCurlsRep(motion:CMDeviceMotion){
        let gravity_x = round(motion.gravity.x)*100
        let gravity_z = round(motion.gravity.z)*100
        
        if(gravity_x < -99 && gravity_z == 0){
            self.lifted = true
        }
        
        //Arm ist wieder nach unten gerichtet,
        //Wiederholung abgeschlossen wenn handgelenk richtig ausgerichtet ist
        //z muss 0 sein und x = 100
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
    
    func checkButterflyRep(motion:CMDeviceMotion){
        let gravity_y = round(motion.gravity.y)*100
        let rotRate_y = round(motion.rotationRate.y*1000)/10
        
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
    
    func checkButterflyReverseRep(motion:CMDeviceMotion){
        let gravity_y = round(motion.gravity.y)*100
        let rotRate_y = round(motion.rotationRate.y*1000)/10
        
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
    
    func checkCrunchesRep(motion:CMDeviceMotion){
        let gravity_x = round(motion.rotationRate.x*1000)/10
        let gravity_z = round(motion.gravity.z)*100
        
        if(gravity_x < 10 && gravity_z < 1){
            self.lifted = true;
        }
        
        if(!self.lifted){
            return
        }
        else if(gravity_x > 10 && gravity_z < -99 ){
            self.lifted = false;
            repitionDone();
        }
        
    }
    
    func checkTimeBasedRep(){
        if(!self.started){
            repTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(repReminder), userInfo: nil, repeats: true)
            self.started = true
        }
    }
    
    func repReminder(){
        repTimerCounter += 1;
        
        if(repTimerCounter % 2 == 1){
            WKInterfaceDevice.current().play(.start)
        }
        else{
            WKInterfaceDevice.current().play(.stop)
            repitionDone()
        }
    }
}
