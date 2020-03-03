//
//  injuryTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 12.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class injuryTVC: UITableViewCell {

    public var content : String?{
        get {
            return self.contentLabel.text
        }
        set{
            self.contentLabel.text = newValue
        }
    }
    
    @IBOutlet var contentLabel: UILabel!
    
	@IBOutlet var locationtext: UILabel!
	
}
