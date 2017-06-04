//
//  PushToNextController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

extension DurchfuehrungInterfaceController{
    
    func zielErreicht(){
        neededTime.invalidate()
        let erreichteLeistungen = [self.uebungsName, String(self.wiederholung), String(self.satz), String(self.time), String(self.zuErreichendeSaetze), String(self.gewicht)]
        resetTraining()
        pushController(withName: "Uebersicht", context: erreichteLeistungen)
    }
    
    func resetTraining(){
        timeCounter = 5
        time = 0
        wiederholung = 0
    }
    
    
}
