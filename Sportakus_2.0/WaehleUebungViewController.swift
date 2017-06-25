//
//  WaehleUebungViewController.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 25.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class WaehleUebungViewController: UIViewController {
    
    
    /**
     
     Plan wird via prepareSeguel übergeben.
     
     */
    
    var plan: Plan!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    
    /**
     
        Wenn Segue "UebungAuswaehlen" heisst und den ViewController UebungAuswaehlenViewController hat, füge den Plan hinzu.
        
        ODER
     
        Wenn Segue "UebungErstellen" heisst und den ViewController UebungErstellenViewController hat, füge den Plan hinzu.
     
     */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UebungAuswaehlen" {
            if let destination = segue.destination as? UebungAuswaehlenViewController{
                destination.plan = plan
            }
        }  else if segue.identifier == "UebungErstellen" {
            if let destination = segue.destination as? UebungErstellenViewController{
                destination.plan = plan
            }
        }
    }

}
