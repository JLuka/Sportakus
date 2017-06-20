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

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var wcSession: WCSession!
    let defaults = UserDefaults.standard
    let plaeneDefaults = UserDefaults.init(suiteName: "Plaene")
    
    var plaene = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        wcSession = WCSession.default()
        wcSession.delegate = self
        wcSession.activate()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        //print ("error in activationDidCompleteWith error")
    }
    
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
        
        
    }
    @IBAction func pushNextController() {
        if defaults.object(forKey: "wieVielePlaene") == nil || plaene.count == 0 {
            let viewInformationen = ["keinePlaeneVorhanden", "FirstView"]
            presentController(withName: "ErrorHandler", context: viewInformationen)
        }else{
            pushController(withName: "Plaene", context: plaene)
        }
        
    }

}
