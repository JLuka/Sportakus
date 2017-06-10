//
//  UebungsUebersichtInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


class UebungsUebersichtInterfaceController: WKInterfaceController {

    @IBOutlet var uebungsName: WKInterfaceLabel!
    @IBOutlet var gewichtLabel: WKInterfaceLabel!
    @IBOutlet var saetzeLabel: WKInterfaceLabel!
    @IBOutlet var wiederholungsLabel: WKInterfaceLabel!
    
    let defaults = UserDefaults.standard
    let uebungenDefaults = UserDefaults.init(suiteName: "Uebungen")
    
    var uebung = [String]()
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        uebung = uebungenDefaults?.object(forKey: String(context as! Int)) as! [String]
        fillViewWithContent()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func fillViewWithContent(){
        uebungsName.setText(uebung[0])
        if uebung[1] == "0" {
            gewichtLabel.setText("EG")
        }else{
            gewichtLabel.setText(uebung[1] + "kg")
        }
        
        saetzeLabel.setText(uebung[2])
        wiederholungsLabel.setText(uebung[3])
    }
    
    @IBAction func startExerciseButtonPressed() {
        pushController(withName: "Durchfuehrung", context: uebung)
    }


}
