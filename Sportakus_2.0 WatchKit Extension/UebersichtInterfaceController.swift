//
//  UebersichtInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


class UebersichtInterfaceController: WKInterfaceController {
    @IBOutlet var ueberschriftLabel: WKInterfaceLabel!
    @IBOutlet var satzLabel: WKInterfaceLabel!
    @IBOutlet var wiederholungLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var beendenButton: WKInterfaceButton!
    
    var context = [String]()
    var welcheUebung = Int()
    var zuSpeichernderContext = [String]()
    
    var defaults = UserDefaults.standard

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.context = context as! [String]
        welcheUebung = defaults.object(forKey: "welcheUebung") as! Int
        
        if Int(self.context[2]) == 1 {
            //                          Uebungsname  zuErreichendeSätze      Gewicht      Satz                Wdh             Zeit
            zuSpeichernderContext = [self.context[0], self.context[4], self.context[5], self.context[2], self.context[1], self.context[3]]
            defaults.set(zuSpeichernderContext, forKey: String(welcheUebung))
        }else{
            //                          Satz                Wdh                Zeit
            zuSpeichernderContext = [self.context[2], self.context[1], self.context[3]]
            var vorherGespeicherteDaten = defaults.object(forKey: String(welcheUebung)) as! [String]
            vorherGespeicherteDaten.append(contentsOf: zuSpeichernderContext)
            defaults.set(vorherGespeicherteDaten, forKey: String(welcheUebung))
        }
        
        
        
        fillViewWithContext()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func weiterButtonClicked() {
        pop()
    }
    
    
    
    @IBAction func uebungBeendenButtonClicked() {
        
    }
    
    
    func fillViewWithContext(){
        wiederholungLabel.setText(context[1])
        satzLabel.setText(context[2])
        timeLabel.setText(context[3])
        
        if Int(context[2]) == Int(context[4]) {
            ueberschriftLabel.setText("Glückwunsch")
            beendenButton.setBackgroundColor(UIColor(red:0.52, green:0.80, blue:0.81, alpha:1.0))
        }
    }
    
    

}
