//
//  SmallUnitTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class SmallUnitTableViewCell: UITableViewCell {

    @IBOutlet weak var funkRufName: UILabel!
    
    @IBOutlet weak var crewCount: UILabel!
    
    @IBOutlet weak var unitType: UILabel!
    
    @IBOutlet weak var unitTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
