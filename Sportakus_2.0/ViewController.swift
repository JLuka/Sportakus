//
//  ViewController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 28.05.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewPlan: UITableView!
    var controller: NSFetchedResultsController<Plan>!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    


}

