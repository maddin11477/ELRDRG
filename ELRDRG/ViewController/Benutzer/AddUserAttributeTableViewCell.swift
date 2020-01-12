//
//  AddUserAttributeTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 24.11.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class AddUserAttributeTableViewCell: UITableViewCell {

    @IBOutlet weak var Headline: UILabel!
    @IBOutlet weak var TextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
