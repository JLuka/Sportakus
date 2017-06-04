//
//  DatenEmpfangenTestViewController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 04.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import WatchConnectivity

class DatenEmpfangenTestViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var plan: UILabel!
    
    var wcSession: WCSession!
    
    var allgemeines = [String]()
    
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
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        allgemeines = message["allgemeines"] as! [String]
        
        
        
        self.date.text = allgemeines[0]
        self.plan.text = allgemeines[1]
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
