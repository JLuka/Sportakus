//
//  CommunicationToWatchTest.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import WatchConnectivity

class CommunicationToWatchTest: UIViewController, WCSessionDelegate {
    
    var wcSession: WCSession!
    
    var plaene = ["Brust - Trizeps", "Bauch - Beine", "Rücken - Bizeps", "Ganzkörpertraining"]
    
    var plan1 = ["Bankdrücken", "60", "3", "10", "Brustpresse", "40", "3", "12", "Butterfly", "47", "3", "12", "Kabelzug", "15", "3", "10"]
    
    var plan2 = ["Bauchpresse", "0", "3", "15", "Beinheben", "0", "3", "12", "Boot-Sitzen", "0", "3", "8", "Beinpresse", "70", "3", "20", "Fußheben", "0", "4", "17"]
    
    var plan3 = ["Klimmzüge", "0", "3", "10", "Latzug", "47", "3", "18", "Seilzug", "35", "3", "12", "Dips", "0", "3", "15"]
    
    var plan4 = ["Bankdrücken", "60", "3", "10", "Klimmzüge", "0", "3", "12", "Beinpresse", "75", "3", "12", "Hammer-Curls", "20", "3", "10"]

    override func viewDidLoad() {
        super.viewDidLoad()

        wcSession = WCSession.default()
        wcSession.delegate = self
        wcSession.activate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let message = ["plaene": plaene, "1": plan1, "2": plan2, "3": plan3, "4": plan4]
        
        
        //Send Messages to Watch
        wcSession.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })
        
        // create the alert
        let alert = UIAlertController(title: "Complete", message: "Syncronisation with watch complete.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print ("error in sessionDidBecomeInactive")
    }
    public func sessionDidDeactivate(_ session: WCSession) {
        print ("error in SesssionDidDeactivate")
    }
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        print ("error in activationDidCompleteWith error")
    }
}
