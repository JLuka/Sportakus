//
//  ItemCellArchiv.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 20.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import UIKit

class ItemCellArchiv: UITableViewCell {
    
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var datum: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    
    func configureCell(item: UebungArchiv) {
        
        planName.text = item.planName
        datum.text = item.datum
        textView.text = item.saetzeString

    }
    
}
