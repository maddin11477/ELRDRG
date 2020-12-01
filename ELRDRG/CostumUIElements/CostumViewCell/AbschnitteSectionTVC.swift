//
//  AbschnitteSectionTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.11.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import UIKit
protocol AbschnitteSectionTVCDelegate {
    func addSection(section : BaseSection)
}
class AbschnitteSectionTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var Name: UILabel!
    
    public var section : BaseSection?
    public var delegate : AbschnitteSectionTVCDelegate?
    
    @IBAction func addSection(_ sender: Any) {
        if let sec = self.section
        {
            self.delegate?.addSection(section: sec)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
