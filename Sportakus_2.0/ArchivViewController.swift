//
//  ArchivViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 20.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import CoreData

class ArchivViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableViewArchiv: UITableView!
    var controller: NSFetchedResultsController<UebungArchiv>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewArchiv.dataSource = self
        tableViewArchiv.delegate = self
        attemptFetch()
    }


    
    /**
     
     1. Gibt die Anzahl an Sections zurück.
     
     */
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
        
    }

    
    /**
     
     1. Gibt die Anzahl der Row zurück
     
     */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    
    /**
     
     1. Die Daten werden in eine Zelle geladen und in der View angezeigt.
     
     */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellArchiv
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    /**
     
     1. Die Daten werden an die Zelle weiter gereicht.
     
     */
    
    func configureCell(cell: ItemCellArchiv, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(item: item)
        
        
    }
    
    
    
    /**
     
     1. Die Übungen für das Archiv werden über FetchRequest aus der Datenbank gezogen.
     2. Sortiert wird nach dem planNamen
     3. per PerformFetch wird der Fetch ausgeführt und die Daten geladen
     
     */
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<UebungArchiv> = UebungArchiv.fetchRequest()
        let dataSort = NSSortDescriptor(key: "planName", ascending: false)
        
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
     
     1. Es wird "gehorcht" ob Daten sich im FetchRequest verändern. Wenn ja ändert sich die tableView
     
     */
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewArchiv.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewArchiv.endUpdates()
        
    }
    
    
    /**
     
     Boilerplate Funktionen die ermöglichen die TableView automatisch zu verändern.
     
     */
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableViewArchiv.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableViewArchiv.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableViewArchiv.cellForRow(at: indexPath) as! ItemCellArchiv
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableViewArchiv.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            if let indexPath = newIndexPath {
                tableViewArchiv.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }

}
