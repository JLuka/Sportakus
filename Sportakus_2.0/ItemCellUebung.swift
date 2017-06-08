//
//  ItemCellUebung.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class ItemCellUebung: UITableViewCell {
    @IBOutlet weak var name: UILabel!


    func configureCell(item: Uebung) {
        
        name.text = item.name
    }
    
}
