//
//  TimerExtensions.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 Extension des InterfaceControllers DurchführungInterfaceController, die einen simplen Timer ausführt.
 */
extension DurchfuehrungInterfaceController{
    //Timer Funktion mit einem Interval von einer Sekunde, die jede Sekunde zeitStoppen aufruft.
    func timerStarten(){
        neededTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zeitStoppen), userInfo: nil, repeats: true)
    }
    
    //Zählt die Zeit immer eine Sekunde hoch
    func zeitStoppen(){
        time += 1
    }
}
