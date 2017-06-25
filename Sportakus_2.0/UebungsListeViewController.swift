//
//  UebungsListeViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 04.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import CoreData

class UebungsListeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate  {
    
    
    @IBOutlet weak var tableViewUebung: UITableView!
    
    var plan : Plan!
    var uebungen : [Uebung]!
    
    @IBOutlet weak var cellName: UITableViewCell!
    
    var controller: NSFetchedResultsController<Plan>!
    
    
    /**
     1. TableView wird inizialisiert.
     2. Die Übungen werden aus dem Plan gezogen und zu einem Uebungsarray geparst.
     
     */

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableViewUebung.dataSource = self
        tableViewUebung.delegate = self
        uebungen = plan.toUebungen?.allObjects as! [Uebung]

    }
    
    
    
    /**
     
     1. attemptFetch() wird ausgeführt um Daten aus der Datenbank zu laden.
     2. Die tableView wird beim eintreffen von Änderungen neu geladen.
     
     */
    
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
        
        tableViewUebung.reloadData()
        
    }

    
    /**
     
     Gibt die Anzahl der Rows einer TableView wieder.
     
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uebungen.count
    }
    
    
    /**
     
     - Zelle wird für die TableView inizialisiert.
     - Das Übungsarray wird an die Zelle übergeben und mit Werten aus einer einzelnen Übung gefüllt
     
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = uebungen[indexPath.row].name
        
        return cell
        
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
                
                let item = self.plan
                let resultItem = item?.toUebungen?.allObjects as! [Uebung]
                var uebung: Uebung!
                
                for i in 0 ..< resultItem.count {
                    
                    if resultItem[i].name == self.uebungen[indexPath.row].name {
                        
                        uebung = resultItem[i]
                        
                    }
                }

                
                self.performSegue(withIdentifier: "UebungEditieren", sender: uebung)
                self.tableViewUebung.setEditing(false, animated: true)
            }
            
        }
        
        delete.backgroundColor = UIColor.lightGray

        return [delete]
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
        
        let plan1 = controller.fetchedObjects
        var resultPlan: Plan!
        
        for i in 0 ..< plan1!.count {
        
            if plan1?[i].name == plan.name {
            
                resultPlan = plan1?[i]
            
            }
        }
        
        uebungen = resultPlan.toUebungen?.allObjects as! [Uebung]
        
        controller.delegate = self
        
    }

    
    /**
     1. Via Click auf eine Zelle wird der Plan aus dem Controller gezogen.
     2. Alle Übungen die in einem Plan sind werden in ein Übungsarray übertragen.
     3. Über performSegue wird die View geändert und der Wert "UebungEditieren" hinzugefügt. Dies bewirkt das das ausgewählte Item im UebungErstellenController als itemToEdit makiert wird.
     
     
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = plan
            let resultItem = item?.toUebungen?.allObjects as! [Uebung]
            var uebung: Uebung!
            
            for i in 0 ..< resultItem.count {
                
                if resultItem[i].name == uebungen[indexPath.row].name {
                    
                    uebung = resultItem[i]
                    
                }
            }

            performSegue(withIdentifier: "UebungEditieren", sender: uebung)
            
        }
    }
    
    
    /**
     
     Wenn Segue "UebungEditieren" heisst und den ViewController UebungErstellenViewController hat, füge den Plan hinzu.
     
     ODER
     
     Wenn Segue "UebungErstellen" heisst und den ViewController WaehleUebungViewController hat, füge den Plan hinzu.
     
     */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UebungEditieren" {
            
            if let destination = segue.destination as? UebungErstellenViewController{
                if let item = sender as? Uebung {
        
                    destination.itemToEdit = item
                    destination.plan = plan
                }
            }
            
        }  else if segue.identifier == "UebungErstellen" {
            
            if let destination = segue.destination as? WaehleUebungViewController{

                    destination.plan = plan
            }
            
        }

    }

}
