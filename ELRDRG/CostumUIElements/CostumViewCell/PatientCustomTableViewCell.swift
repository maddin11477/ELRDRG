//
//  PatientCustomTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ID: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var birthDate: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var hospital: UILabel!
    
    @IBOutlet weak var unit: UILabel!
    
    @IBOutlet weak var child: UILabel!
    
    @IBOutlet weak var sht: UILabel!
    
    @IBOutlet weak var heatinjury: UILabel!
    
    @IBOutlet weak var helicopter: UILabel!
    
    public var alreadyLoaded : Bool = false
    public var background_View : UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutMargins.left = 10
        layoutMargins.top = 10
        layoutMarginsDidChange()
        
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
