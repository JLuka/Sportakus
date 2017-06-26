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
    
    var trainingsdaten = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wcSession = WCSession.default()
        wcSession.delegate = self
        wcSession.activate()
        tableViewPlan.dataSource = self
        tableViewPlan.delegate = self
        
        attemptFetch()
    }
    

    
    /**
     
     1. Gibt die Anzahl an Sections zurück
     
     */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
        
    }
    
    
    
    /**
     
     Wenn Segue "PlanEditieren" heisst und den ViewController PlanErstellenViewController hat, füge den Plan hinzu.
     
     ODER
     
     Wenn Segue "UebungsListe" heisst und den ViewController UebungsListeViewController hat, füge den Plan hinzu.
     
     */
    
    
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

    /**
     
     1. Gibt die anzahl an rows zurück
     
     */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    /**
    
     1. Die zelle mit dem Identifier ItemCell wird gesucht.
     2. Es wird per configureCell die Zelle vorbereitet und mit Content gefüllt.
     
     */
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellPlan
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    /**
     
     1. Daten werden an eine Zelle weiter gegeben und mit Content gefüllt.
     
     */
    
    func configureCell(cell: ItemCellPlan, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
        
    }
    
    /**
     
     1. Eine fetchRequest wird erstellt.
     2. Plan wird nach Namen sortiert. Dies bietet die Erweiterungsmöglichkeit später die Daten nach belieben zu sortieren.
     3. FetchResultController wird inizialisiert.
     4. Daten werden versucht aus der Datenbank zu lesen. Abgefangen wird es mit einer try Catch funktion.
     5. Der Plan wird erstellt.
     6. Der Name des Plans wird in der Titelleiste angezeigt.
     7. Die Übungen in einem Plan werden einem Übungsarray hinzugefügt.
     
     */

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
    
    
    /**
     
     1. Delete Button für Swipe wird angelegt.
     2. Der Plan mit den jeweiligen Übungen wird aus der Datenbank gezogen.
     3. Jeder Übung wird ein Delete Button zugewiesen
     4. Über performSegue wird die View geändert und der Wert "UebungEditieren" hinzugefügt. Dies bewirkt das das ausgewählte Item im UebungErstellenController als itemToEdit makiert wird.
     5. Der Delete Button wird in seine Ausgangsposition anmiert. Anderfalls wäre er kontinuierlich offen.
     
     */

    
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
    

    /**
     
     1. Per Klick auf eine Zelle wird die Segue mit dem Identifier UebungsListe gestartet
     
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "UebungsListe", sender: item)
            
        }
        
    }
    
    /**
     
     1. Es wird "gehorcht" ob Daten sich im FetchRequest verändern. Wenn ja ändert sich die tableView
     
     */
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewPlan.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewPlan.endUpdates()
        
    }
    
    
    /**
     
     Boilerplate Funktionen die ermöglichen die TableView automatisch zu verändern.
     
     */
    
    
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
    
    
    /**
     
     1. Die Daten werden mit prepareData vorbereitet
     2. Der String mit den behinhaltenden Daten werden an die Watch geschickt per "sendMessage"
     3. Ist der Vorgang erfolgreich wird ein Alert angezeigt.
     
     */
    
    @IBAction func watchClicked(_ sender: UIBarButtonItem) {
        
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
    
    /**
     
     1. Zuerst wird der Message die an die Watch geschickt wird der Plan Name hinzugefügt.
     2. Danach werden die einzelnen Übungen eines Plan ausgelesen und die Daten der einzelnen Übungen in ein Array geschrieben.
     3. Dies wird solange wiederholt bis keine Übungen mehr vorhanden sind.
     
     */
    
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
    
    
    /**
     
     1. Zuerst wird der Plan Name und das Datum aus der an uns geschickten Dictionary gelesen. 
     2. Die Daten wie Sätze gewicht und wiederholungen sowie Sekunden werden ebenfalls abgescheichert.
     3. Nun wird ein neues ÜbungArchiv objekt erstellt und die Daten werden dahin übertragen.
     4. Nun werden die ersten Daten gelöscht die bereits ausgelesen wurden um mehr übersicht zu haben.
     5. Nun werden die Übungen einzeln ausgelesen. Nach jedem auslesen wird die ausgelesene Übung gelöscht und das Array verkleinert.
     6. Am Ende wird Das neue Objekt in der Datenbank gespeichert und die trainingsdaten gelöscht.
     
     */
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
            self.trainingsdaten = message["trainingsdaten"] as! [[String]]

        print(trainingsdaten)
        
        var planName = trainingsdaten[0]
        var datum = trainingsdaten[1]
        
        _ = trainingsdaten[2][0]
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
        
        
        trainingsdaten.remove(at: 0)
        trainingsdaten.remove(at: 0)
        
        
        
        item.saetzeString = ""
        
        
        var counter = 0
        var uebungsName = ""
        
        
        for _ in 0 ..< trainingsdaten.count {
            
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

        ad.saveContext()
        
        trainingsdaten.removeAll()
    }
    
    /**
     
     1. Boilerplate Daten für die Watch Connectivity
     
     */

    
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

