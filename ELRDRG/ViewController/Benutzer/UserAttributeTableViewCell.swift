//
//  UserAttributeTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.11.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class UserAttributeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Description: UILabel!
    
    @IBOutlet weak var Content: UILabel!
    
    enum PropertyType {
        case eMail
        case PhoneNumber
        case area
        case UserType
    }
    
    public var propertyType : PropertyType?
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
