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
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        plaene = defaults.object(forKey: "plaene") as! [String]
        loadTableData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
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
        var welcherPlan = rowIndex + 1
        defaults.set(String(welcherPlan), forKey: "welcherPlan")
        pushController(withName: "Uebungen", context: nil)
    }


}
