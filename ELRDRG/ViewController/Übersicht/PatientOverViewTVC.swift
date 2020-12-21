//
//  PatientOverViewTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 09.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class PatientOverViewTVC: UITableViewCell {

    
    
    @IBOutlet var lbl_sk1: UILabel!
    @IBOutlet var lbl_sk2: UILabel!
    @IBOutlet var lbl_sk3: UILabel!
    @IBOutlet var lbl_noneSK: UILabel!
    @IBOutlet var lbl_dead: UILabel!
    
   public func loadInfo()
   {
        //Lade Patienten aus Context und errechne Schadenskonto
       
        let victims = DataHandler().getVictims()
        self.lbl_sk1.text = "x " + String(victims.filter{$0.category == 1}.count)
        self.lbl_sk2.text = "x " + String(victims.filter{$0.category == 2}.count)
        self.lbl_sk3.text = "x " + String(victims.filter{$0.category == 3}.count)
        self.lbl_noneSK.text = "x " + String(victims.filter{$0.category == 4}.count)
        self.lbl_dead.text = "x " + String(victims.filter{$0.category == 5}.count)
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
