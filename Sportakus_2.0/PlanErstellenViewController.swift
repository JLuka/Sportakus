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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnClicked(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let plan = Plan(context: context)
        let uebung = Uebung(context: context)
        let uebung1 = Uebung(context: context)
        let uebungen = plan.mutableSetValue(forKey: "Uebungen")
        
        
        uebung.name = "uebung1"
        uebung1.name = "uebung122"
        
        uebungen.add(uebung)
        uebungen.add(uebung1)
        
        
        if planName.text != "" {
            
            plan.name = planName.text
            
            // save Data
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
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


}
