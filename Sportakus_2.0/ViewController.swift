//
//  ViewController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 28.05.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewPlan: UITableView!
    var plaene : [Plan] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPlan.dataSource = self
        tableViewPlan.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get the data from CoreData
        
        getData()
        
        // reload the tableview
        
        tableViewPlan.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plaene.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let plan = plaene[indexPath.row]
        cell.textLabel?.text = plan.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "UebungsListe", sender: plaene[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "PlanErstellen" {
            
            _ = segue.destination as! PlanErstellenViewController
            
        } else if segue.identifier == "watch" {
            
            _ = segue.destination as! CommunicationToWatchTest
            
        } else {
            
            let guest = segue.destination as! UebungsListeViewController
            guest.plan = sender as! Plan
            
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            plaene = try context.fetch(Plan.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            let plan = plaene[indexPath.row]
            
            context.delete(plan)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                plaene = try context.fetch(Plan.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    



}

