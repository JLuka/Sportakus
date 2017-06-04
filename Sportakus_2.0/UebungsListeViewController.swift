//
//  UebungsListeViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 04.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class UebungsListeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var tableViewUebung: UITableView!
    var plan : Plan!
    var uebungen : [Uebung]!
    var plaene : [Plan] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUebung.dataSource = self
        tableViewUebung.delegate = self
        uebungen = plan.uebungen?.allObjects as! [Uebung]
        planName.text = plan.name

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uebungen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let plan = uebungen[indexPath.row]
        cell.textLabel?.text = plan.name!
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            context.delete(uebungen[indexPath.row])
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                plaene = try context.fetch(Plan.fetchRequest())
                
                if let i = plaene.index(where: { $0.name == plan.name }) {
                    plan = plaene[i]
                }
                
                uebungen = plan.uebungen?.allObjects as! [Uebung]
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    



}
