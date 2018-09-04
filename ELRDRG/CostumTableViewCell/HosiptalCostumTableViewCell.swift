//
//  HosiptalCostumTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 04.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class HosiptalCostumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var City: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
