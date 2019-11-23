//
//  BenutzerTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 08.10.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class BenutzerTableViewCell: UITableViewCell {

    @IBOutlet weak var txt_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
