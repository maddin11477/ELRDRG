//
//  MissionCostumTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 28.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class MissionCostumTableViewCell: UITableViewCell {

    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var Reason: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
