//
//  UebersichtInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 InterfaceController zur View "Uebersicht"
 Die View zeigt alle Informationen zur zuletzt durchgeführten Uebung an
 Der Controller speichert den übergebenen Context in der Suite erledigte Uebungen und zeigt diesen in der View an
 */
class UebersichtInterfaceController: WKInterfaceController {
    /**
     Outlets für die Labels in der View
     */
    @IBOutlet var ueberschriftLabel: WKInterfaceLabel!
    @IBOutlet var satzLabel: WKInterfaceLabel!
    @IBOutlet var wiederholungLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var beendenButton: WKInterfaceButton!
    
    var context = [String]()
    var welcheUebung = Int()
    var zuSpeichernderContext = [String]()
    
    var defaults = UserDefaults.standard
    var erledigteUebungDefaults = UserDefaults.init(suiteName: "ErledigteUebung")
    
    var testArray = [String]()

    /**
     Speichert den uebergebenen context in der Variable context
     Wenn die UserDefault Suite "ErledigteUebung leer ist, wird diese angelegt und die Werte:
        - Uebungsname
        - zuErreichendeSätze
        - Gewicht
        - Satz
        - Wiederholungen
        - Zeit
     gespeichert.
     Wenn die Suite schon vorhanden ist, werden die Werte
        - Satz
        - Wiederholungen
        - Zeit
     der Suite hinzugefügt
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.context = context as! [String]
        welcheUebung = defaults.object(forKey: "welcheUebung") as! Int
        
        if Int(self.context[2]) == 1 {
            //Löschen des Suite Inhalt
            if Bundle.main.bundleIdentifier != nil {
                erledigteUebungDefaults?.removePersistentDomain(forName: "ErledigteUebung")
            }
            //                          Uebungsname  zuErreichendeSätze      Gewicht      Satz                Wdh             Zeit
            zuSpeichernderContext = [self.context[0], self.context[4], self.context[5], self.context[2], self.context[1], self.context[3]]
            erledigteUebungDefaults?.set(zuSpeichernderContext, forKey: String(welcheUebung))
            erledigteUebungDefaults?.synchronize()
        }else{
            //                          Satz                Wdh                Zeit
            zuSpeichernderContext = [self.context[2], self.context[1], self.context[3]]
            var vorherGespeicherteDaten = erledigteUebungDefaults?.object(forKey: String(welcheUebung)) as! [String]
            vorherGespeicherteDaten.append(contentsOf: zuSpeichernderContext)
            erledigteUebungDefaults?.set(vorherGespeicherteDaten, forKey: String(welcheUebung))
            erledigteUebungDefaults?.synchronize()
        }
        fillViewWithContext()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    /**
     Wird ausgelöst, wenn der Weiter Button geklickt wurde
     Wechselt zur vorherigen View
     */
    @IBAction func weiterButtonClicked() {
        pop()
    }
    
    /**
     Wird ausgelöst, wenn der Uebung Beenden Button geklickt wurde
     Wechselt zur View Uebungen und übergibt als Context als String, welche Uebung ausgeführt wurde
     */
    @IBAction func uebungBeendenButtonClicked() {
        pushController(withName: "Uebungen", context: String(welcheUebung))
    }
    
    /**
     Methode, um die View mit dem übergebenen Context zu füllen
     Wenn der aktuelle Satz und der zuErreichendeSatz übereinstimmen,
     wird die Überschrift in "Glückwunsch" geändert und die Farbe des Beenden Buttons geändert
     */
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
