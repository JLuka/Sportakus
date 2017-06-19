//
//  UebungErstellenViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit
import CoreData

class UebungErstellenViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var gewichtField: UITextField!
    @IBOutlet weak var wiederholungenField: UITextField!
    @IBOutlet weak var saetzeField: UITextField!
    
    var itemToEdit: Uebung?
    var plan: Plan!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        if itemToEdit != nil {
            loadItemdata()
        }

    }


    @IBAction func btnClicked(_ sender: UIButton) {
        var item: Uebung!
        
        if itemToEdit == nil {
            
            item = Uebung(context: context)
        } else {
            
            item = itemToEdit
        }
        
        if let title = nameField.text {
            
            item.name = title
        }
        
        if let gewicht = gewichtField.text {
            
            item.gewicht = (gewicht as NSString).doubleValue
        }
        
        if let wiederholungen = wiederholungenField.text {
            
            item.wiederholungen = (wiederholungen as NSString).intValue
        }
        
        if let saetze = saetzeField.text {
            
            item.saetze = (saetze as NSString).intValue
        }
        
        plan.mutableSetValue(forKey: "toUebungen").add(item)
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)


    }
    
    
    
    func loadItemdata() {
        
        if let item = itemToEdit {
            
            nameField.text = item.name
            gewichtField.text = "\(item.gewicht)"
            wiederholungenField.text = "\(item.wiederholungen)"
            saetzeField.text = "\(item.saetze)"
            
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
