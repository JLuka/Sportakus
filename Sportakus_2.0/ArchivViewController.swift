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



    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellArchiv
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    
    func configureCell(cell: ItemCellArchiv, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(item: item)
        
        
    }
    
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
    
    
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewArchiv.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableViewArchiv.endUpdates()
        
    }
    
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
