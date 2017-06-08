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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUebung.dataSource = self
        tableViewUebung.delegate = self
        uebungen = plan.toUebungen?.allObjects as! [Uebung]

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get the data from CoreData
    attemptFetch()
        // reload the tableview
        
        tableViewUebung.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uebungen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = uebungen[indexPath.row].name
        
        return cell
        
    }
    
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UebungEditieren" {
            
            if let destination = segue.destination as? UebungErstellenViewController{
                if let item = sender as? Uebung {
        
                    destination.itemToEdit = item
                    destination.plan = plan
                }
            }
            
        }  else if segue.identifier == "UebungErstellen" {
            
            if let destination = segue.destination as? UebungErstellenViewController{

                    destination.plan = plan
            }
            
        }

    }
    
    
    
    
    
    
    
   

}
