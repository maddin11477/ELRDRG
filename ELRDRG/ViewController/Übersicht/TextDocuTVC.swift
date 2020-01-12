//
//  TextDocuTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 10.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class TextDocuTVC: UITableViewCell {
    @IBOutlet var lbl_content: UILabel!
    @IBOutlet var lbl_Date: UILabel!
    @IBOutlet var lbl_Time: UILabel!
    @IBOutlet var backgroundLabel: UILabel!
    
    
    var entry : Documentation!
    
    public func setup(entry : Documentation)
    {
        self.entry = entry
        lbl_content.text = entry.content ?? ""
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        lbl_Date.text = dateFormatterPrint.string(from: entry.created!)
        dateFormatterPrint.dateFormat = "HH:mm"
        lbl_Time.text = dateFormatterPrint.string(from: entry.created!)
        
        self.backgroundLabel.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.backgroundLabel.layer.cornerRadius = 5
        self.backgroundLabel.layer.shadowOffset = CGSize(width: -1, height: -1)
        self.backgroundLabel.layer.shadowOpacity = 1.0
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
