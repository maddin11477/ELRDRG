//
//  UnitSelectCostumTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 09.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class UnitSelectCostumTableViewCell: UITableViewCell {

    @IBOutlet weak var Callsign: UILabel!
    
    
    @IBOutlet weak var crewCount: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var pictureBox: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
