//
//  ViewController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 28.05.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewPlan: UITableView!
    var controller: NSFetchedResultsController<Plan>!
    var wcSession: WCSession!
    
    var plan : Plan!
    var plaene: [Plan]!
    var uebungen : [Uebung]!
    var uebungenString = [""]
    var plaeneString = [""]
    var messageString: [String: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wcSession = WCSession.default()
        wcSession.delegate = self
        wcSession.activate()
        tableViewPlan.dataSource = self
        tableViewPlan.delegate = self
        
       // generateTestData()
        attemptFetch()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlanEditieren" {
            
            if let destination = segue.destination as? PlanErstellenViewController {
                if let item = sender as? Plan {
                    destination.itemToEdit = item
                }
            }
            
        } else if segue.identifier == "UebungsListe" {
            
            if let destination = segue.destination as? UebungsListeViewController {
                if let item = sender as? Plan {
                    destination.plan = item
                }
            }
            
        }

        
        
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellPlan
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    func configureCell(cell: ItemCellPlan, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
        
    }
    
    

    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Plan> = Plan.fetchRequest()
        let dataSort = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [dataSort]

        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        controller.delegate = self
        
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Editieren") { (action, indexPath) in
            if let objs = self.controller.fetchedObjects , objs.count > 0 {
                
                let item = objs[indexPath.row]
                
                self.performSegue(withIdentifier: "PlanEditieren", sender: item)
                self.tableViewPlan.setEditing(false, animated: true)
            }

        }
        
        delete.backgroundColor = UIColor.lightGray
        
        

        
        return [delete]
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "UebungsListe", sender: item)
            
        }
        
    }
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewPlan.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewPlan.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableViewPlan.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableViewPlan.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableViewPlan.cellForRow(at: indexPath) as! ItemCellPlan
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableViewPlan.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            if let indexPath = newIndexPath {
                tableViewPlan.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    @IBAction func refreshWatchClicked(_ sender: UIBarButtonItem) {
        
        prepareData()
        
        let message = messageString
        
        
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
    func prepareData() {
        
        plaeneString.removeAll()
        uebungenString.removeAll()
        messageString.removeAll()
        
        
        plaene = controller.fetchedObjects
        
        
        for k in 0 ..< plaene.count  {
            plaeneString.append((controller.fetchedObjects?[k].name)!)
        }
        
        messageString["plaene"] = plaeneString
        
        var count:Int
        count = 1
        
        for i in 0 ..< plaene.count  {
            plan = plaene[i]
            uebungen = plan.toUebungen?.allObjects as! [Uebung]
            for j in 0 ..< uebungen.count  {
                let nameUebung = uebungen![j].name!
                uebungenString.append(nameUebung)
                uebungenString.append("\(uebungen![j].gewicht)")
                uebungenString.append("\(uebungen![j].saetze)")
                uebungenString.append("\(uebungen[j].wiederholungen)")
            }
            messageString["\(count)"] = uebungenString
            uebungenString.removeAll()
            count += 1
        }
        
        
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

