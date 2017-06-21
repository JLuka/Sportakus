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
    
    func countRepsForHammerCurls(){
        motionManager.startDeviceMotionUpdates()
        motionManager.deviceMotionUpdateInterval = 0.5
        var lifted = false
        
        if motionManager.isDeviceMotionAvailable{
            let handler: CMDeviceMotionHandler = {
                (motion: CMDeviceMotion?, error: Error?) -> Void in

                
                let pitch = self.degrees(radians: motion!.attitude.pitch)
                //TODO
                let roll = self.degrees(radians: motion!.attitude.roll)
                let yaw = self.degrees(radians: motion!.attitude.yaw)
              
                print("pitch: \(round(pitch*1000)/1000)")
                print("\n")
                print("roll: \(round(roll*1000)/1000)")
                print("\n")
                print("yaw: \(round(yaw*1000)/1000)")
                print("\n\n")
                
                
                //END TODO
                
                self.startLabel.setEnabled(true)
                
                
                //Try
                if(pitch < -60){
                    if(!lifted){
                        WKInterfaceDevice.current().play(.click)
                    }
                    lifted = true;
                }
                if(pitch > -40 && lifted){
                    lifted = false;
                    
                    
                    
                    //@Emel! Musst die Methode benutzen, um die Wiederholungen hochzuzählen!
                    self.increaseReps()
                    
                    //TODO print
                    print("\(self.wiederholung)")
                    self.startLabel.setTitle("\(self.wiederholung)")
                    WKInterfaceDevice.current().play(.failure)
                }
                
                if self.wiederholung == self.zuErreichendeWiederholungen {
                    self.zielErreicht()
                    WKInterfaceDevice.current().play(.success)
                }
                
            }
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: handler)
        }else{
            
        }
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
}
