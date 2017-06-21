//
//  PlaeneInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 InterfaceController zur View "Plaene"
 Die View zeigt alle vorhanden Trainingsplaene an
 Der Controller nutzt die Plaene aus dem UserDefault
 Zeigt diese in einer Table View an
 */
class PlaeneInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!

    var plaene = [String]()
    let defaults = UserDefaults.standard
    let plaeneDefaults = UserDefaults.init(suiteName: "Plaene")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if defaults.object(forKey: "plaene") != nil {
                  plaene = defaults.object(forKey: "plaene") as! [String]
        }
        loadTableData()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    /**
     Methode um die Table View mit den Trainingsplannamen zu füllen
     
     # Important Informations #
        - Table Identifier = "Table"
        - NumberOfRows = Anzahl von Plaenen
        - Label in jeder Row ist in TableRowController.swift deklariert
     */
    func loadTableData(){
        table.setNumberOfRows(plaene.count, withRowType: "Table")
        
        for (index, content) in plaene.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.label.setText(content)
        }
    }
    
    /**
     Table function um zum nächsten View zu wechseln ("Uebungen")
     Inkl. dem Row Index um den ausgewählten Plan weiter zu geben
     
     # Important #
     Wenn keine Übungen in einem Plan vorhanden sind, wird an den DynamicErrorInterfaceController weitergeleitet
     */
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let welcherPlan = rowIndex + 1
        defaults.set(String(welcherPlan), forKey: "welcherPlan")
        
        let helper = plaeneDefaults?.object(forKey: String(welcherPlan)) as! [String]
        
        if helper.count == 0{
            let viewInformationen = ["keineUebungenVorhanden", "PlaeneView"]
            pushController(withName: "ErrorHandler", context: viewInformationen)
        }else{
            pushController(withName: "Uebungen", context: nil)
        }
    }
}
