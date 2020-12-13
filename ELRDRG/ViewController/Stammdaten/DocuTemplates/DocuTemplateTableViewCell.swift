//
//  DocuTemplateTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import UIKit

class DocuTemplateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbl_Template: UILabel!
    @IBOutlet weak var lbl_counter: UILabel!
    
    private var docuTemplate : DocumentationTemplate?
    
    public func set(template : DocumentationTemplate)
    {
        self.docuTemplate = template
        self.lbl_Template.text = template.content
        self.lbl_counter.text = String(template.useCounter)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
