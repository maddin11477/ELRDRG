//
//  DocumentationTableViewCell.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationTableViewCell: UITableViewCell {
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var CreationDate: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var Thumbnail: UIImageView!
    
    public var alreadyLoaded : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
