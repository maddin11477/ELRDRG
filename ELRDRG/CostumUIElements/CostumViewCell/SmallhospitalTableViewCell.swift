//
//  SmallhospitalTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 04.02.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class SmallhospitalTableViewCell: UITableViewCell {

    @IBOutlet weak var City: UILabel!
    
    @IBOutlet weak var Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
