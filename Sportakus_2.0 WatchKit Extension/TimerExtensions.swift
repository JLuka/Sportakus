//
//  TimerExtensions.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

extension DurchfuehrungInterfaceController{
    func timerStarten(){
        neededTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zeitStoppen), userInfo: nil, repeats: true)
    }
    
    //Zählt die Zeit immer eine Sekunde hoch
    func zeitStoppen(){
        time += 1
    }
}
