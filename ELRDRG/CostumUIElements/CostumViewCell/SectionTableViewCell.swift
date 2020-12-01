//
//  SectionTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol SectionTableViewCellDelegate {
    func addSection(section : BaseSection)
}

class SectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Name: UILabel!
    
    var section : BaseSection?
    var delegate : SectionTableViewCellDelegate?
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var allwaysExistsSwitch: UISwitch!
    @IBOutlet weak var txt_Number: UITextField!
    
    @IBOutlet weak var lbl_numberDescription: UILabel!
    
    
    
    @IBAction func addSection(_ sender: Any) {
        if let sec = self.section
        {
            self.delegate?.addSection(section: sec)
        }
        
    }
    
    
    @IBAction func allwaysExitsSwitch(_ sender: Any) {
        let state = (sender as! UISwitch).isOn
        section?.allwaysExits = state
        if state
        {
            txt_Number.isHidden = false
            stepper.isHidden = false
            lbl_numberDescription.isHidden = false
            
        }
        else
        {
            txt_Number.isHidden = true
            stepper.isHidden = true
            lbl_numberDescription.isHidden = true
        }
    }
    
    
    @IBAction func stepperClick(_ sender: Any)
    {
        self.txt_Number.text = String(Int(stepper.value))
        if let sec = section {
            sec.counter = Int16(stepper.value)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    public func setup()
    {
        if let sec = section
        {
            self.stepper.value = Double(sec.counter)
            self.txt_Number.text = String(sec.counter)
            if sec.allwaysExits {
                self.allwaysExistsSwitch.isOn = true
                self.stepper.isHidden = false
                self.txt_Number.isHidden = false
                self.lbl_numberDescription.isHidden = false
            }
            else
            {
                self.allwaysExistsSwitch.isOn = false
                self.stepper.isHidden = true
                self.txt_Number.isHidden = true
                self.lbl_numberDescription.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
