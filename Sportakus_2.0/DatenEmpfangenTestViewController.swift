//
//  DatenEmpfangenTestViewController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 04.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

class DatenEmpfangenTestViewController: UIViewController, WCSessionDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var plan: UILabel!
    @IBOutlet weak var uebungsname: UILabel!
    @IBOutlet weak var gewicht: UILabel!
    
    var wcSession: WCSession!
    var controller: NSFetchedResultsController<Plan>!
    
    var trainingsdaten = [[String]]()
    
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
        trainingsdaten = message["trainingsdaten"] as! [[String]]
        
        print(trainingsdaten)
        
        var planName = trainingsdaten[0]
        var datum = trainingsdaten[1]
        
        let uebungName = trainingsdaten[2][0]
        let saetze = trainingsdaten[2][1]
        let gewicht = trainingsdaten[2][2]
        let gemachteWiederholungen = trainingsdaten[2][4]
        let sekunden = trainingsdaten[2][5]
        
        var item: UebungArchiv!
        var satzItem: [Saetze]! = [Saetze]()
        item = UebungArchiv(context: context)
        
        item.planName = planName[0]
        item.datum = datum[0]
        item.saetze = (saetze as NSString).intValue
        item.gewicht = (gewicht as NSString).doubleValue
       // item.geschaffteWiederholungen = (gemachteWiederholungen as NSString).intValue
        
        
        trainingsdaten.remove(at: 0)
        trainingsdaten.remove(at: 0)
        
        

        item.saetzeString = ""
       // satzItem.nameUebung = uebungName
      //  satzItem.wiederholungen = (gemachteWiederholungen as NSString).intValue
       // satzItem.sekunden = (sekunden as NSString).intValue
        

        var counter = 0
        var uebungsName = ""
        
        
        for j in 0 ..< trainingsdaten.count {
            
            uebungsName = trainingsdaten[0][0]
            trainingsdaten[0].remove(at: 0)
            trainingsdaten[0].remove(at: 0)
            trainingsdaten[0].remove(at: 0)
            counter = trainingsdaten[0].count/3
        for i in 0 ..< counter  {
          let tempItem = Saetze(context: context)
            satzItem.append(tempItem)
            satzItem[i].nameUebung = uebungsName
            satzItem[i].wiederholungen = (trainingsdaten[0][1] as NSString).intValue
            satzItem[i].sekunden = (trainingsdaten[0][2] as NSString).intValue
            item.mutableSetValue(forKey: "toSaetze").add(satzItem[i])
            item.saetzeString = item.saetzeString! + uebungsName + gemachteWiederholungen + sekunden
            trainingsdaten[0].remove(at: 0)
            trainingsdaten[0].remove(at: 0)
            trainingsdaten[0].remove(at: 0)
        
        }
            trainingsdaten.remove(at: 0)
        }
        
        
        
       // item.mutableSetValue(forKey: "toSaetze").add(satzItem)
        
        

        
        
        ad.saveContext()
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
