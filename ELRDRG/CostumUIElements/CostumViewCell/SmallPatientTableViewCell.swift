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
	public var pattern : UnitPattern?
    
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
		if let car = fahrzeug
		{
			if let pat = self.patient
			{
				var setAlone = true
				car.removeFromPatient(pat)
				if let units = pat.getUnits()
				{
					for unit in units
					{
						if unit.section != nil
						{
							setAlone = false
						}
					}
				}
				if setAlone
				{
					pat.section = car.section
					car.section?.addToVictims(pat)
				}
				else
				{

				}

				DataHandler().saveData()
				delegate?.reloadTable()
			}
		}

		if let pat = self.patient
		{

				if let units = pat.getUnits()
				{


					for unit in units
					{
						unit.removeFromPatient(pat)
					}
					if units.count > 0
					{
						pat.section = units[0].section
					}
				}
				else
				{
					pat.section?.removeFromVictims(pat)
					pat.section = nil
				}

				DataHandler().saveData()
				delegate?.reloadTable()

		}

		if let pat = self.pattern?.victim
		{
			if let units = pat.getUnits()
			{


				for unit in units
				{
					unit.removeFromPatient(pat)
				}
				if units.count > 0
				{
					pat.section = units[0].section
				}
			}
			else
			{
				pat.section?.removeFromVictims(pat)
				pat.section = nil
			}

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
