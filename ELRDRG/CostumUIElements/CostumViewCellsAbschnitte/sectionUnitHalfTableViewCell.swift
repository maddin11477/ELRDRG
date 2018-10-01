//
//  sectionUnitHalfTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class sectionUnitHalfTableViewCell: UITableViewCell {

    @IBOutlet weak var callSign: UILabel!
    
    
    @IBOutlet weak var crewCount: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var typeImage: UIImageView!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var category: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
