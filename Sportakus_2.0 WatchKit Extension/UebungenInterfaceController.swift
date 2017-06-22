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

/**
 InterfaceController zur View "Uebungen"
 Die View zeigt alle vorhanden Uebungen
 Der Controller nutzt die Uebungen aus dem UserDefault Suite Plaene
 Zeigt diese in einer Table View an
 
 # Wichtig #
 Als Context wird übergeben, welcher Plan ausgewählt wurde
 */
class UebungenInterfaceController: WKInterfaceController, WCSessionDelegate {

    var wcSession: WCSession!
    
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var beendenButton: WKInterfaceButton!
    
    /**
     Konstanten um auf den jeweiligen UserDefault zuzugreigen
     */
    let defaults = UserDefaults.standard
    let uebungenDefaults = UserDefaults.init(suiteName: "Uebungen")
    let plaeneDefaults = UserDefaults.init(suiteName: "Plaene")
    let erledigteUebungDefaults = UserDefaults.init(suiteName: "ErledigteUebung")
    let abgeschlosseneUebungen = UserDefaults.init(suiteName: "AbgeschlosseneUebungen")
    
    /**
     Variablen um die Daten aus den User Default Suits zu speichern
     */
    var uebungen = [String]()
    var uebungsNamen = [String]()
    var context = String()
    var geschaffteUebung = String()
    var geschaffteUebungen = [String]()
    var schonEineUebungGemacht = Bool()
    var abgeschlosseneUebung = [String]()
    
    
    /**
     Speichert den Context in einer Variablen
     Speichert die Uebungen in uebungen[String]
     Wenn der Context nicht nil ist, wird die übergebene, gemachte Uebung zum Uebungen Suite hinzugefügt
     Wenn noch keine Uebung ausgeführt wurde, wird die Suite Abgeschlossene Uebungen gelöscht
     Speichert aus dem Array uebungen nur die Uebungsnamen in einem neuen Array uebungsNamen
     Blendet den Beenden Button aus, wenn noch keine Uebung ausgeführt wurde und ändert die Farbe, wenn alle Uebungen einmal ausgeführt wurden
     Füllt die Table View mit Uebungsnamen
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.context = defaults.object(forKey: "welcherPlan") as! String
        uebungen = plaeneDefaults?.object(forKey: self.context) as! [String]
        
        if context != nil {
            schonEineUebungGemacht = true
            geschaffteUebung = context as! String
            appendGeschaffteUebungToSuite()
            saveAccomplishedExercises()
        }else{
            schonEineUebungGemacht = false
            deleteSuite()
        }
        
        //Nur die Uebungsnamen aus dem array ziehen
        for (index, content) in uebungen.enumerated() {
            if index % 4 == 0 {
                uebungsNamen.append(content)
            }
        }
        
        if geschaffteUebungen.count == 0 {
            beendenButton.setAlpha(0.0)
        }else if geschaffteUebungen.count - 1 == uebungsNamen.count {
            beendenButton.setBackgroundColor(UIColor(red:0.52, green:0.80, blue:0.81, alpha:1.0))
            beendenButton.setAlpha(1.0)
        }else{
            beendenButton.setAlpha(1.0)
        }
        
        //Löschen der Suite
        if Bundle.main.bundleIdentifier != nil {
            uebungenDefaults?.removePersistentDomain(forName: "Uebungen")
        }
        
        //Einzelne Übungen in DefaultUser laden.
        loadTableData()
        uploadUserDefaultExercises()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    /**
     Methode um die Table View mit den Uebungsnamen zu füllen und
     die Schrift der schon gemachten Uebungen transparenter zu machen
     */
    func loadTableData(){
        table.setNumberOfRows(uebungsNamen.count, withRowType: "UebungenTable")
        for (index, content) in uebungsNamen.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.uebungenLabel.setText(content)
            for (_, content) in geschaffteUebungen.enumerated(){
                if String(index) == content {
                    row.uebungenLabel.setAlpha(0.5)
                }
            }
        }
    }
    
    /**
     Speichert alle Uebungen aus dem Plan mit den zugehörigen Werten: 
        - Gewicht
        - Sätze
        - Wiederholungen
     in einem eigenen Suite "Uebungen"
     Der Key um auf diese Daten zuzugreifen ist, eine fortlaufende Zahl, angefangen bei 0
     */
    func uploadUserDefaultExercises(){
        var counter = 0;
        _ = String()
        
        for i in 0..<uebungsNamen.count {
            var uebung = [String]()
            for _ in 0..<4 {
                uebung.append(uebungen[counter])
                counter += 1
            }
            uebungenDefaults?.set(uebung, forKey: String(i))
            uebung.removeAll()
        }
    }
    
    /**
     Methode um zum nächsten ViewController zu pushen.
     Wenn eine Übung, die geklickt wurde, schonmal ausgeführt wurde
     (im aktuellen Training)
     wird der Controller DynamicErrorInterfaceController aufgerufen
     Wenn nicht, wird zur View UebungsUebersicht gepushed.
     
     # Wichtig #
     Der RowIndex, der ausgewählten Uebung, muss als Context uebergeben werden
     */
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if schonEineUebungGemacht{
            if istVorhanden(rowIndex: rowIndex) {
                //Fehlermeldung / Warnung
                let errorMessage = ["UebungSchonAusgeführt", "Uebungen", String(rowIndex)]
                pushController(withName: "ErrorHandler", context: errorMessage)
            }else{
                defaults.set(rowIndex, forKey: "welcheUebung")
                pushController(withName: "UebungsUebersicht", context: rowIndex)
            }

        }else{
            defaults.set(rowIndex, forKey: "welcheUebung")
            pushController(withName: "UebungsUebersicht", context: rowIndex)
        }
    }
    
    /**
     Methode um zu überprüfen, ob eine Uebung schon ausgeführt wurde 
     und dementsprechend im Array geschaffteUebungen vorhanden ist.
     
     # Wichtig #
     Return: Boolean
     
     */
    func istVorhanden(rowIndex: Int) -> Bool{
        for (_, content) in geschaffteUebungen.enumerated(){
            if String(rowIndex) == content {
                return true
            }
        }
        return false
    }
    
    /**
     Button um das Training zu beenden und die Trainingsdaten an das iPhone zu senden
     
     sendet eine Message an das Handy, bestehend aus allen Trainingsdaten aus der Suite "abgeschlosseneUebungen"
     Präsentiert eine Alert, wenn die Nachricht erfolgreich zugestellt wurde und wenn das Senden fehlgeschlagen ist.
     */
    @IBAction func trainingBeendenButtonPressed() {
        
        wcSession = WCSession.default()
        wcSession.delegate = self

        var gemachteUebungen = abgeschlosseneUebungen?.object(forKey: "GeschaffteUebungen") as! [String]
        let gemachteUebungenAnzahl = gemachteUebungen.count - 1
        let dateAndTime = getCurrentDateAndTime()
        let planName = abgeschlosseneUebungen?.object(forKey: "planname") as! String
        var durchgefuehrteUebungen = [[String]]()
        
        durchgefuehrteUebungen.append([planName])
        durchgefuehrteUebungen.append([dateAndTime])
        
        for i in 0..<gemachteUebungenAnzahl {
            let uebungsname = gemachteUebungen[i+1]
            let currentExercise = abgeschlosseneUebungen?.object(forKey: uebungsname) as! [String]
            durchgefuehrteUebungen.append(currentExercise)
        }

        let message = ["trainingsdaten": durchgefuehrteUebungen]
        
        //Send Messages to Watch
        if wcSession.isReachable {
            var fehlerTitel = "Erledigt"
            var fehlerMessage = "Ihre Daten wurden erfolgreich übertragen."
            
            wcSession.sendMessage(message, replyHandler: nil, errorHandler: {
                error in
                fehlerMessage = "Ihre Daten konnten nicht übertragen werden. Vermutlich ist ihr Handy nicht in Reichweite."
                fehlerTitel = "Fehler"
            })
            
            deleteSuite()
            let h0 = {self.popToRootController()}
            let action1 = WKAlertAction(title: "OK", style: .default, handler:h0)
            self.presentAlert(withTitle: fehlerTitel, message: fehlerMessage, preferredStyle: .alert, actions: [action1])
            
        }else{
            let h0 = { }
            let action1 = WKAlertAction(title: "OK", style: .default, handler:h0)
            self.presentAlert(withTitle: "Fehler", message: "Ihre Daten konnten nicht übertragen werden. Vermutlich ist ihr Handy nicht in Reichweite.", preferredStyle: .alert, actions: [action1])
        }
    }

    /**
     Methode, die das aktuelle Datum und die aktuelle Zeit als String zurück gibt
     */
    func getCurrentDateAndTime() -> String{
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let todaysDate = dateFormatter.string(from: date)
        return todaysDate
    }
    
    /**
     Methode um eine geschaffte Uebung in die Suite abgeschlosseneUebungen zu speichern (Die Uebungsnummer)
     Wenn die Suite noch leer ist, wird sie neu angelegt und der erste Wert wird gespeichert.
     Wenn sie nicht leer ist, wird der neue Wert einfach hinzugefügt
     */
    func appendGeschaffteUebungToSuite(){
        if  abgeschlosseneUebungen?.object(forKey: "GeschaffteUebungen") == nil {
            //Ein Hilfsarray, welches gespeichert wird, damit das gespeicherte Objekt beim nächsten Durchlauf als String Array in eine Variable gespeichert werden kann
            let helpArray = ["Uebungen", geschaffteUebung]
            abgeschlosseneUebungen?.set(helpArray, forKey: "GeschaffteUebungen")
            geschaffteUebungen = abgeschlosseneUebungen?.object(forKey: "GeschaffteUebungen") as! [String]
            abgeschlosseneUebungen?.synchronize()
        }else {
            geschaffteUebungen = abgeschlosseneUebungen?.object(forKey: "GeschaffteUebungen") as! [String]
            geschaffteUebungen.append(geschaffteUebung)
            abgeschlosseneUebungen?.set(geschaffteUebungen, forKey: "GeschaffteUebungen")
            abgeschlosseneUebungen?.synchronize()
        }
    }
    
    /**
     Methode um eine geschaffte Uebung in die Suite erledigteUebungen zu speichern (Die Uebungswerte - > Sätze, Gewichte, Wiederholungen)
     Wenn die Suite noch leer ist, wird sie neu angelegt und der erste Wert wird gespeichert.
     Wenn sie nicht leer ist, wird der neue Wert einfach hinzugefügt
     */
    func saveAccomplishedExercises(){
        _ = [String]()
        
        if abgeschlosseneUebungen?.object(forKey: "planname") == nil {
            var plaene = defaults.object(forKey: "plaene") as! [String]
            abgeschlosseneUebungen?.set(plaene[Int(context)!-1], forKey: "planname")
            let uebung = erledigteUebungDefaults?.object(forKey: geschaffteUebung) as! [String]
            abgeschlosseneUebungen?.set(uebung, forKey: geschaffteUebung)
            abgeschlosseneUebungen?.synchronize()
        }else{
            let uebung = erledigteUebungDefaults?.object(forKey: geschaffteUebung) as! [String]
            abgeschlosseneUebungen?.set(uebung, forKey: geschaffteUebung)
            abgeschlosseneUebungen?.synchronize()
        }
    }
    
    /**
     Methode um die Suite abgeschlosseneUebungen zu löschen
     */
    func deleteSuite(){
        if Bundle.main.bundleIdentifier != nil {
            abgeschlosseneUebungen?.removePersistentDomain(forName: "AbgeschlosseneUebungen")
        }
    }
    
    /**
     WatchConnectivity Methode
     
     Wenn die activation nicht geklappt hat, wird eine Fehlermeldung geprinted
     */
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        print ("error in activationDidCompleteWith error")
    }
}
