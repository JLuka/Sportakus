//
//  InterfaceController.swift
//  Sportakus_2.0 WatchKit Extension
//
//  Created by Jannis Lindenberg on 28.05.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

/**
 Interface Controller zur ersten View
 Die View zeigt den StartScreen
 Controller empfängt Daten des iPhones
 Speichert diese im NSUserDefault
 Und wechselt dann zum nächsten ViewController
 */
class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var wcSession: WCSession!
    let defaults = UserDefaults.standard
    let plaeneDefaults = UserDefaults.init(suiteName: "Plaene")
    let uebungenDefaults = UserDefaults.init(suiteName: "Uebungen")
    let erledigteUebungDefaults = UserDefaults.init(suiteName: "ErledigteUebung")
    let abgeschlosseneUebungen = UserDefaults.init(suiteName: "AbgeschlosseneUebungen")
    
    var plaene = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    /**
     WatchConnectivity Session aktivieren
     Health Daten auhtorisieren lassen
     */
    override func willActivate() {
        super.willActivate()
        
        HealthManager.sharedInstance.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                print("\(error)")
            }
        }
        
        wcSession = WCSession.default()
        wcSession.delegate = self
        if wcSession.activationState != .activated {
            wcSession.activate()
        }
        
        eventuelVorhandeneWerteInDenSuitesLöschen()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        if wcSession.activationState == .activated {
            
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
    }
    
    /**
     Methode um die ggf. vorhandenen Werte in den Suites 
     - abgeschlosseneUebungen
     - ErledigteUebungen
     - Uebungen 
     und den Wert für den aktuellen Plan zu löschen
     */
    func eventuelVorhandeneWerteInDenSuitesLöschen(){
        if Bundle.main.bundleIdentifier != nil {
            abgeschlosseneUebungen?.removePersistentDomain(forName: "AbgeschlosseneUebungen")
        }
        if Bundle.main.bundleIdentifier != nil {
            erledigteUebungDefaults?.removePersistentDomain(forName: "ErledigteUebung")
        }
        if Bundle.main.bundleIdentifier != nil {
            uebungenDefaults?.removePersistentDomain(forName: "Uebungen")
        }
        if defaults.object(forKey: "welcherPlan") != nil {
            defaults.removeObject(forKey: "welcherPlan")
        }
    }
    
    /**
     Did receive Message Methode
        - löscht als erstes ggf. bestehend gespeicherte Daten
        - empfängt Daten der Uhr als String Dictionary
        - speichert neu empfangene Daten im NSUserDefault und im PlaeneSuite
        - Lässt eine alert aufploppen, wenn die Daten erfolgreich empfangen wurden
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        
        let wieVielePlaene = message.count - 1
        plaene = message["plaene"] as! [String]
        
        defaults.set(wieVielePlaene, forKey: "wieVielePlaene")
        
        var helper = String()
        
        for i in 0...wieVielePlaene {
            helper = String(i)
            
            if i == 0 {
                defaults.set(message["plaene"], forKey: "plaene")
            }else{
                plaeneDefaults?.set(message[helper], forKey: helper)
            }
        }
        defaults.synchronize()
        
        let h0 = {self.popToRootController()}
        let action1 = WKAlertAction(title: "OK", style: .default, handler:h0)
        self.presentAlert(withTitle: "Erledigt", message: "Ihre Daten wurden erfolgreich empfangen.", preferredStyle: .alert, actions: [action1])
    }
    
    /**
     Methode die zum nächsten ViewController wechselt
     
     # Important Notes #
        wechselt nur zum Controller PlaeneInterfaceController, wenn:
            - eine Message empfangen wurde und
            - mehr als ein Plan vorhanden ist
        andernfalls wechselt die View zum DynamicErrorInterfaceController
     */
    @IBAction func pushNextController() {
        if defaults.object(forKey: "wieVielePlaene") == nil || plaene.count == 0 {
            let viewInformationen = ["keinePlaeneVorhanden", "FirstView"]
            presentController(withName: "ErrorHandler", context: viewInformationen)
        }else{
            pushController(withName: "Plaene", context: plaene)
        }
    }
}
