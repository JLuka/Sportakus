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
    
    var controller: NSFetchedResultsController<Uebung>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUebung.dataSource = self
        tableViewUebung.delegate = self
        uebungen = plan.toUebungen?.allObjects as! [Uebung]

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get the data from CoreData
    
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
    

    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "UebungEditieren", sender: item)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UebungEditieren" {
            
            if let destination = segue.destination as? UebungErstellenViewController{
                if let item = sender as? Uebung {
                    destination.itemToEdit = item
                }
            }
            
        }  else if segue.identifier == "UebungErstellen" {
            
            if let destination = segue.destination as? UebungErstellenViewController{

                    destination.plan = plan
            }
            
        }

    }
    
    
    
    
    
    
    
   

}
