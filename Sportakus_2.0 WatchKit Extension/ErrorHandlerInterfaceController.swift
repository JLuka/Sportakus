//
//  ErrorHandlerInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


class ErrorHandlerInterfaceController: WKInterfaceController {

    @IBOutlet var alertTextLabel: WKInterfaceLabel!
    
    var context = Int()
    
    let defaults = UserDefaults.standard
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.context = context as! Int
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func OkayButtonPressed() {
        defaults.set(self.context, forKey: "welcheUebung")
        pushController(withName: "UebungsUebersicht", context: self.context)
    }
    
    @IBAction func BackButtonPressed() {
        //pushController(withName: "Uebungen", context: self.context)
        pop()
    }
    
}
