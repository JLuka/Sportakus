//
//  UebungAuswaehlenViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 25.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class UebungAuswaehlenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var plan: Plan!
    var uebungen = [Uebung]()

    @IBOutlet weak var tableViewUebung: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewUebung.dataSource = self
        tableViewUebung.delegate = self
        
        prepareData()
    }
    
    
    
    /**
     
     Gibt die Anzahl der Rows einer TableView wieder.
     
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return uebungen.count
    
    }
    
    
    
    /**
     
     - Zelle wird für die TableView inizialisiert.
     - Das Übungsarray wird an die Zelle übergeben und mit Werten aus einer einzelnen Übung gefüllt
     
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let uebungen_cell = uebungen[indexPath.row]
        
        cell.textLabel?.text = uebungen_cell.name

        return cell
    }
    
    
    
    /**
     
     - Via Click auf die Zelle wird die ausgewählte Übung mittels Relationship zu dem Plan zugewiesen.
     - Mit saveContext() wird in der Core DATA gespeichert.
     - popViewController schließt den aktuellen ViewController
     
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        plan.mutableSetValue(forKey: "toUebungen").add(uebungen[indexPath.row])
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    
    }
    
    
    
    /**
     - Dummy Übungen werden erstellt.
     - 1. Datenbank Objekt wird via (context:context) erstellt.
     - 2. Daten werden zur Übung hinzugefügt.
     - 3. uebungen.append fügt die erstelle Übung einem Übungsarray hinzu.
     
     */
    
    func prepareData() {
    
        let butterfly = Uebung(context:context)
        butterfly.name = "Butterfly"
        butterfly.gewicht = 20.0
        butterfly.saetze = 3
        butterfly.wiederholungen = 10
        uebungen.append(butterfly)
        
        
        let hammer = Uebung(context:context)
        hammer.name = "Hammer-Curls"
        hammer.gewicht = 5.0
        hammer.saetze = 1
        hammer.wiederholungen = 10
        uebungen.append(hammer)
        
        
        let bizeps = Uebung(context:context)
        bizeps.name = "Bizeps-Curls"
        bizeps.gewicht = 10.0
        bizeps.saetze = 3
        bizeps.wiederholungen = 8
        uebungen.append(bizeps)
        
        let crunch = Uebung(context:context)
        crunch.name = "Crunches"
        crunch.gewicht = 0.0
        crunch.saetze = 2
        crunch.wiederholungen = 25
        uebungen.append(crunch)
        
        let beinpresse = Uebung(context:context)
        beinpresse.name = "Beinpresse"
        beinpresse.gewicht = 40.0
        beinpresse.saetze = 2
        beinpresse.wiederholungen = 10
        uebungen.append(beinpresse)
    
    }
    
}
