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
    
    
    /**
     
     Wenn itemtoEdit nicht null ist füll das Item via loadDataItem()
     
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemToEdit != nil {
            loadItemdata()
        }

    }

    
    /**
     
     Bei Button CLicked
     1. Erstelle eine Übung
     2. Wenn itemToEdit null ist, inizialisiere die Übung via Datenbank Klasse (context: context). Wenn itemToEdit !null ist, ersetze itemToEdit mit item.
     3. Auslesen der Text Inputs und füllen der einzelnen Paramenter. Zudem werden die Werte aus den Text Inputs in Double oder Int geparst falls nötig.
     4. Die erstelle Übung wird mittels Relationship zu dem Plan zugewiesen. "toUebungen".
     5. Mit saveContext() wird in der Core DATA gespeichert.
     6. popViewController schließt den aktuellen ViewController.
     
     */

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
    
    
    /**
     
     Daten werden in die Textfelder geladen.
     
     */
    
    
    func loadItemdata() {
        
        if let item = itemToEdit {
            
            nameField.text = item.name
            gewichtField.text = "\(item.gewicht)"
            wiederholungenField.text = "\(item.wiederholungen)"
            saetzeField.text = "\(item.saetze)"
            
        }
        
    }

    
    /**
     
     Button Clicked:
     
     1. Ausgewählte Übung wird zum löschen gekennzeichnet.
     2. Mit saveContext() werden die Befehle in der Datenbank übernommen und die Übung wird gelöscht.
     3. popViewController schließt den aktuellen ViewController.
     
     
     */
    
    @IBAction func deleteClicked(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        
        navigationController?.popViewController(animated: true)
    }

    
    
    
    
    
    
    

}
