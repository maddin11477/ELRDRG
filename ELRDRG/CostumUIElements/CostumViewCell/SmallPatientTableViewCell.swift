//
//  SmallPatientTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol changedUnitDelegate {
    func reloadTable()
}

class SmallPatientTableViewCell: UITableViewCell {

    
    @IBOutlet weak var PatID: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    public var patient : Victim?
    public var fahrzeug : Unit?
    
    
    @IBOutlet weak var destination: UILabel!
    
    @IBOutlet var removeHospitalBtn: UIButton!
    @IBOutlet var removePatientBtn: UIButton!
    public var delegate : changedUnitDelegate?
    
    @IBOutlet var hospitalInfoStateColorElement: UILabel!
    
    @IBAction func removeHospital(_ sender: Any) {
        
        self.patient?.hospital = nil
        DataHandler().saveData()
        delegate?.reloadTable()
        
        
    }
    @IBAction func removePatient(_ sender: Any) {
        if let pat = self.patient
        {
            self.fahrzeug?.removeFromPatient(pat)
            DataHandler().saveData()
            delegate?.reloadTable()
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
