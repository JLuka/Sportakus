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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        if itemToEdit != nil {
            loadItemdata()
        }

        // Do any additional setup after loading the view.
    }

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
    
    
    
    
    func newAlert(alert: String) -> UIAlertController {
        let alert = UIAlertController(title: "error", message: alert, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    
    
    func loadItemdata() {
        
        if let item = itemToEdit {
            
            planName.text = item.name
            
                
            }
        
        
    }
    
    @IBAction func deleteClicked(_ sender: UIBarButtonItem) {
        
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
 
}
