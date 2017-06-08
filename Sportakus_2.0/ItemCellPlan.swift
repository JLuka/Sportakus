//
//  ItemCellPlan.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class ItemCellPlan: UITableViewCell {
    @IBOutlet weak var name: UILabel!


    func configureCell(item: Plan) {
        
        name.text = item.name
    }
}
