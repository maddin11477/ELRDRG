//
//  PatientUITVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 08.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

public protocol presentViewController {
    func presentController(controller : UIViewController)
}

class PatientUITVC: UITableViewCell {
    @IBOutlet var lbl_id: UILabel!
    @IBOutlet var lbl_firstName: UILabel!
    @IBOutlet var lbl_lastName: UILabel!
    @IBOutlet var lbl_SK: UILabel!
    @IBOutlet var lbl_hospital: UILabel!
    @IBOutlet var lbl_unit: UILabel!
    var patient : Victim?
    public var alreadyLoaded : Bool = false
    
    @IBOutlet var backgroundLabel: UILabel!
    public var delegate : presentViewController?
    @IBAction func Info_click(_ sender: Any)
    {
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let patientController = storyBoard.instantiateViewController(withIdentifier: "PatientPopOverVC") as! PatientPopOverVC
        patientController.patient = patient
        //patientController.popoverPresentationController?.sourceView = self.contentView
        patientController.modalPresentationStyle = .formSheet
        if let sourceController = delegate
        {
            sourceController.presentController(controller: patientController)
        }
        
    }
    
    
    public func setPatient(Patient patient : Victim)
    {
        lbl_id.text = String(patient.id)
        lbl_firstName.text = patient.firstName ?? ""
        lbl_lastName.text = patient.lastName ?? ""
		lbl_hospital.text = patient.hospital?.name ?? ""
		var fahrzeuge : String = ""
		if let units = patient.fahrzeug?.allObjects as? [Unit]
		{
			for unit in units
			{
				if unit != units[units.count - 1]
				{
					fahrzeuge = fahrzeuge + (unit.callsign ?? "") + ", "
				}
				else
				{
					fahrzeuge = fahrzeuge + (unit.callsign ?? "")
				}
			}
		}

		lbl_unit.text = fahrzeuge

        lbl_SK.text = String(patient.category)
       
        lbl_SK.textColor = .black

        switch patient.category {
        case 1:
            lbl_SK.backgroundColor = .red
        case 2:
            lbl_SK.backgroundColor = .orange
        case 3:
            lbl_SK.backgroundColor = .green
        case 4:
			lbl_SK.text = "?"
            lbl_SK.backgroundColor = .lightGray
        case 5:
			lbl_SK.textColor = UIColor.white
			lbl_SK.text = "tot"
            lbl_SK.backgroundColor = .black
        default:
            lbl_SK.backgroundColor = .clear
        }
        self.patient = patient
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins.left = 10
        layoutMargins.top = 10
        layoutMarginsDidChange()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
