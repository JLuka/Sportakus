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


class UebungenInterfaceController: WKInterfaceController, WCSessionDelegate {

    var wcSession: WCSession!
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var beendenButton: WKInterfaceButton!
    
    let defaults = UserDefaults.standard
    let uebungenDefaults = UserDefaults.init(suiteName: "Uebungen")
    let plaeneDefaults = UserDefaults.init(suiteName: "Plaene")
    let erledigteUebungDefaults = UserDefaults.init(suiteName: "ErledigteUebung")
    var abgeschlosseneUebungen = UserDefaults.init(suiteName: "AbgeschlosseneUebungen")
    
    
    
    var uebungen = [String]()
    var uebungsNamen = [String]()
    var context = String()
    var geschaffteUebung = String()
    var geschaffteUebungen = [String]()
    var schonEineUebungGemacht = Bool()
    var abgeschlosseneUebung = [String]()
    
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
        
        if geschaffteUebungen.count - 1 == uebungsNamen.count {
            beendenButton.setBackgroundColor(UIColor(red:0.52, green:0.80, blue:0.81, alpha:1.0))
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
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func loadTableData(){
        
        table.setNumberOfRows(uebungsNamen.count, withRowType: "UebungenTable")
        
        for (var index, content) in uebungsNamen.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.uebungenLabel.setText(content)
            
            for (context, content) in geschaffteUebungen.enumerated(){
                if String(index) == content {
                    row.uebungenLabel.setAlpha(0.5)
                }
            }
        }
    }
    
    
    
    func uploadUserDefaultExercises(){
        var counter = 0;
        let uebungsNummer = String()
        
        
        for i in 0..<uebungsNamen.count {
            var uebung = [String]()
            for j in 0..<4 {
                uebung.append(uebungen[counter])
                counter += 1
            }
            uebungenDefaults?.set(uebung, forKey: String(i))
            uebung.removeAll()
        }
    }
    
    
    //Push to next Controller
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if schonEineUebungGemacht{
            if istVorhanden(rowIndex: rowIndex) {
                //Fehlermeldung / Warnung
                pushController(withName: "Error", context: rowIndex)
            }else{
                defaults.set(rowIndex, forKey: "welcheUebung")
                pushController(withName: "UebungsUebersicht", context: rowIndex)
            }

        }else{
            defaults.set(rowIndex, forKey: "welcheUebung")
            pushController(withName: "UebungsUebersicht", context: rowIndex)
        }
    }
    
    func istVorhanden(rowIndex: Int) -> Bool{
        for (context, content) in geschaffteUebungen.enumerated(){
            if String(rowIndex) == content {
                return true
            }
        }
        return false
    }
    
    
    
    //Button zum Beenden des Trainings und zum senden der Trainingsdaten an das Handy
    @IBAction func trainingBeendenButtonPressed() {
        wcSession = WCSession.default()
        wcSession.delegate = self
        wcSession.activate()

        var gemachteUebungen = abgeschlosseneUebungen?.object(forKey: "GeschaffteUebungen") as! [String]
        var gemachteUebungenAnzahl = gemachteUebungen.count - 1
        let dateAndTime = getCurrentDateAndTime()
        let planName = abgeschlosseneUebungen?.object(forKey: "planname") as! String
        var durchgefuehrteUebungen = [[String]]()
        
        durchgefuehrteUebungen.append([planName])
        durchgefuehrteUebungen.append([dateAndTime])
        
        for i in 0..<gemachteUebungenAnzahl {
            var uebungsname = gemachteUebungen[i+1]
            var currentExercise = abgeschlosseneUebungen?.object(forKey: uebungsname) as! [String]
            durchgefuehrteUebungen.append(currentExercise)
        }

        
        let message = ["trainingsdaten": durchgefuehrteUebungen]
        
        
        //Send Messages to Watch
        wcSession.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })

    }
    
    func getCurrentDateAndTime() -> String{
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let todaysDate = dateFormatter.string(from: date)
        return todaysDate
    }
    
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
    
    func saveAccomplishedExercises(){
        var stringArray = [String]()
        
        if abgeschlosseneUebungen?.object(forKey: "planname") == nil {
            var plaene = defaults.object(forKey: "plaene") as! [String]
            abgeschlosseneUebungen?.set(plaene[Int(context)!-1], forKey: "planname")
            var uebung = erledigteUebungDefaults?.object(forKey: geschaffteUebung) as! [String]
            abgeschlosseneUebungen?.set(uebung, forKey: geschaffteUebung)
            abgeschlosseneUebungen?.synchronize()
        }else{
            var uebung = erledigteUebungDefaults?.object(forKey: geschaffteUebung) as! [String]
            abgeschlosseneUebungen?.set(uebung, forKey: geschaffteUebung)
            abgeschlosseneUebungen?.synchronize()
        }
    }
    
    
    func deleteSuite(){
        if Bundle.main.bundleIdentifier != nil {
            abgeschlosseneUebungen?.removePersistentDomain(forName: "AbgeschlosseneUebungen")
        }
    }
    
    
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        print ("error in activationDidCompleteWith error")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    }
    
    
}
