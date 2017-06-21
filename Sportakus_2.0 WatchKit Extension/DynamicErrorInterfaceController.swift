//
//  DynamicErrorInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 20.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation

/**
 Interface Controller zur ErrorView zur Darstellung eines Errors zu fehlenden Plaenen oder fehlenden Uebungen
 Die View zeigt eine Fehlermeldung, wenn kein Plan zur Verfügung steht oder ein Plan keine Uebungen enthält
 Controller empfängt eine Fehlermeldung als Context und zeigt diese an
 */
class DynamicErrorInterfaceController: WKInterfaceController {
    
    @IBOutlet var titelLabel: WKInterfaceLabel!
    @IBOutlet var errorMessageLabel: WKInterfaceLabel!
    @IBOutlet var backButton: WKInterfaceButton!
    
    var errorMessageInformations = [String]()

    /**
     speichert den übergebenen Context, setzt den Titel der View mit "Zurück"
     ruft fillView auf
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        errorMessageInformations = context as! [String]
        self.setTitle("zurück")
        fillView()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    /**
     füllt die View mit Kontext
        - disabled den Zurück Button
        - Setzt ein Titel
        - füllt das errorMessage mit dem entsprechenden Kontext (keine Übungen vorhanden oder keine Pläne vorhanden)
     */
    func fillView(){
        if errorMessageInformations[0] == "keinePlaeneVorhanden" {
            backButton.setEnabled(false)
            backButton.setAlpha(0)
            titelLabel.setText("Fehler")
            errorMessageLabel.setText("Es sind noch keine \nTrainingspläne vorhanden. \nBitte übertragen sie zuerst Pläne von ihrem Handy.")
        }else if errorMessageInformations[0] == "keineUebungenVorhanden" {
            backButton.setEnabled(false)
            backButton.setAlpha(0)
            titelLabel.setText("Fehler")
            errorMessageLabel.setText("Dieser Plan enthält keine Übungen. \nBitte fügen sie ihrem Trainingsplan zuerst Übungen hinzu.")
        }
    }
    /**
     Funktion um zur vorherigen View zurück zu kehren
     */
    @IBAction func backButtonPressed() {
        pop()
    }
}
