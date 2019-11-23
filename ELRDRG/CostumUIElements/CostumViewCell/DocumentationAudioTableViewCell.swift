//
//  DocumentationAudioTableViewCell.swift
//  ELRDRG
//
//  Created by Martin Mangold on 13.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationAudioTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var controllSlider: UISlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var controlButton: RoundButton!
    public var alreadyLoaded : Bool = false
    
    public var attchment : Attachment?
    
    
    @IBAction func controlButtonPushed(_ sender: UIButton)
    {
        if(controlButton.currentTitle == "")
        {
            //controlButton.titleLabel?.text = ""
            controlButton.setTitle("", for: .normal)
            controlButton.setTitleColor(UIColor.red, for: .normal)
            controlButton.borderColor = UIColor.red
        }
        else
        {
            //controlButton.titleLabel?.text = ""
            controlButton.setTitle("", for: .normal)
            controlButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            controlButton.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
        }
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
