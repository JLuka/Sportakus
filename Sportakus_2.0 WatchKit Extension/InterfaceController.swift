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
    
    var plaene = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    /**
     WatchConnectivity Session aktivieren
     */
    override func willActivate() {
        super.willActivate()
        
        wcSession = WCSession.default()
        wcSession.delegate = self
        if wcSession.isReachable == false {
            wcSession.activate()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
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
