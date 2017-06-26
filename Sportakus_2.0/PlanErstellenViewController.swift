//
//  PlanErstellenViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 04.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class PlanErstellenViewController: UIViewController {
    @IBOutlet weak var planName: UITextField!
    
    var itemToEdit: Plan?
    var plaene =  [Plan]()
    
    /**
     
     1. Wenn itemToEdit nicht Null ist werden Daten geladen.
     
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if itemToEdit != nil {
            loadItemdata()
        }

    }
    
    
    /**
     
     1. Wenn itemToEdit null ist wird ein neuer Plan erstellt.
     2. Nach der Eingabe der Plan Daten wird dieser gespeichert.
     3. popViewController wird der Seguel geschlossen.
     
     */

    @IBAction func btnClicked(_ sender: Any) {
        
        
        if planName.text != "" {
            
            var item: Plan!
            
            
            if itemToEdit == nil {
                
                item = Plan(context: context)
            } else {
                
                item = itemToEdit
            }
            
            if let title = planName.text {
                
                item.name = title
            }
            
            
            ad.saveContext()
            
            navigationController?.popViewController(animated: true)
        } else {
            
            self.present(newAlert(alert: "Bitte Name eingeben"), animated: true, completion: nil)
            
        }
    }
    
    /**
     
     Zeigt einen Alert an.
     
     */
    
    
    func newAlert(alert: String) -> UIAlertController {
        let alert = UIAlertController(title: "error", message: alert, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    
    
    /**
     
     1. Wenn ein Plan vorhanden ist wird dieser in die View geladen.
     
     */
    
    
    func loadItemdata() {
        
        if let item = itemToEdit {
            
            planName.text = item.name
                
            }
    }
    
    /**
     
     1. Plan kann gelöscht werden.
     
     */
    
    @IBAction func deleteClicked(_ sender: UIBarButtonItem) {
        
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
 
}
