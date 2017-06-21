//
//  PlaeneInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


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
    
    func loadTableData(){
        table.setNumberOfRows(plaene.count, withRowType: "Table")
        
        for (index, content) in plaene.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.label.setText(content)
        }
    }
    
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
