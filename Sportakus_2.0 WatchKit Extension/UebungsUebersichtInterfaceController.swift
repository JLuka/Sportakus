//
//  UebungsUebersichtInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 InterfaceController zur View "UebungsUebersicht"
 Die View zeigt alle Informationen zur ausgewählten Uebung an
 Der Controller nutzt die Informationen aus der NSUserDefault Suite Uebungen und der Standard Suite
 und füllt die View mit diesen Informationen
 */
class UebungsUebersichtInterfaceController: WKInterfaceController {

    @IBOutlet var uebungsName: WKInterfaceLabel!
    @IBOutlet var gewichtLabel: WKInterfaceLabel!
    @IBOutlet var saetzeLabel: WKInterfaceLabel!
    @IBOutlet var wiederholungsLabel: WKInterfaceLabel!
    
    let defaults = UserDefaults.standard
    let uebungenDefaults = UserDefaults.init(suiteName: "Uebungen")
    
    var uebung = [String]()
    
    /**
     Lädt die Informationen aus der NSUserDefault Suite Uebungen und speichert diese in der Variable uebung
     Ruft fillViewWithContent auf
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        uebung = uebungenDefaults?.object(forKey: String(context as! Int)) as! [String]
        fillViewWithContent()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    /**
     Füllt die View mit Kontent
     
     # Wichtig #
     Wenn das Gewicht 0.0 beträgt, wird das Gewicht auf EG für Eigengewicht gesetzt
     Ansonsten wird das gewählte Gewicht angezeigt
     */
    func fillViewWithContent(){
        uebungsName.setText(uebung[0])
        if uebung[1] == "0.0" {
            gewichtLabel.setText("EG")
        }else{
            gewichtLabel.setText(uebung[1] + "kg")
        }
        saetzeLabel.setText(uebung[2])
        wiederholungsLabel.setText(uebung[3])
    }
    
    /**
     Pushed zur nächsten View (Durchführung) und
     übergibt die UebungsInformationen (Name, Gewicht, Sätze, Wiederholungen)
     */
    @IBAction func startExerciseButtonPressed() {
        pushController(withName: "Durchfuehrung", context: uebung)
    }
}
