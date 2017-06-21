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
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func OkayButtonPressed() {
        defaults.set(self.context, forKey: "welcheUebung")
        pushController(withName: "UebungsUebersicht", context: self.context)
    }
    
    @IBAction func BackButtonPressed() {
        pop()
    }
    
}
