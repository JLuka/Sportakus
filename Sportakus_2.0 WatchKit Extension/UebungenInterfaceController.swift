//
//  UebungenInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


import WatchConnectivity


class UebungenInterfaceController: WKInterfaceController {

    
    @IBOutlet var table: WKInterfaceTable!
    
    let defaults = UserDefaults.standard
    
    var uebungen = [String]()
    var uebungsNamen = [String]()
    var context = String()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.context = defaults.object(forKey: "welcherPlan") as! String
        uebungen = defaults.object(forKey: self.context) as! [String]
        
        
        //Nur die Uebungsnamen aus dem array ziehen
        for (var index, content) in uebungen.enumerated() {
            if index % 4 == 0 {
                uebungsNamen.append(content)
            }
        }
        
        //Einzelne Übungen in DefaultUser laden.
        
        loadTableData()
        uploadUserDefaultExercises()
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func loadTableData(){
        
        table.setNumberOfRows(uebungsNamen.count, withRowType: "UebungenTable")
        
        for (var index, content) in uebungsNamen.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.uebungenLabel.setText(content)
        }
    }
    
    
    
    func uploadUserDefaultExercises(){
        
        
        
        var counter = 0;
        var uebungsNummer = String()
        
        
        for i in 0..<uebungsNamen.count {
            var uebung = [String]()
            uebungsNummer = "Uebung" + String(i)
            for j in 0..<4 {
                uebung.append(uebungen[counter])
                counter += 1
            }
            defaults.set(uebung, forKey: uebungsNummer)
            uebung.removeAll()
        }
    }
    
    
    //Push to next Controller
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        defaults.set(rowIndex, forKey: "welcheUebung")
        pushController(withName: "UebungsUebersicht", context: rowIndex)
    }
    
    
    
    
    
    //Button zum Beenden des Trainings und zum senden der Trainingsdaten an das Handy
    @IBAction func trainingBeendenButtonPressed() {
        
        
        
    }
}
