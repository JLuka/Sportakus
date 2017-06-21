//
//  ErrorHandlerInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 Interface Controller zur ErrorView zur Darstellung eines Errors, wenn eine Übung schon einmal ausgeführt wurde
 Die View zeigt eine Fehlermeldung, wenn eine Übung schonmal ausgeführt wurde und die vorherigen Daten überschrieben werden, wenn die Übung noch einmal ausgeführt wird
 Empfängt als Kontext, welche Übung ausgewählt wurde
 */
class ErrorHandlerInterfaceController: WKInterfaceController {

    @IBOutlet var alertTextLabel: WKInterfaceLabel!
    
    var context = Int()
    
    let defaults = UserDefaults.standard
    /**
     Empfängt den Kontext und speichert diesen (Welche Übung ausgewählt wurde)
     */
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
    /**
     Wechselt zur nächsten View und übergibt als Kontext, welche Uebung ausgeführt werden soll und speichert diese im NSUserDefault
     */
    @IBAction func OkayButtonPressed() {
        defaults.set(self.context, forKey: "welcheUebung")
        pushController(withName: "UebungsUebersicht", context: self.context)
    }
    
    /**
     Wechselt zur vorherigen View
     */
    @IBAction func BackButtonPressed() {
        pop()
    }
    
}
