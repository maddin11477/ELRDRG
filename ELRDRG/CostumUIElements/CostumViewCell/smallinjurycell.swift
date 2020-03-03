//
//  smallinjurycell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 18.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class smallinjurycell: UITableViewCell {

    @IBOutlet weak var injurytext: UILabel!

	@IBOutlet var lbl_location: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
