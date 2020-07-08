//
//  ExportSettingsViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.03.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class ExportSettingsViewController: UITableViewController {


	@IBOutlet var missionInfo_Switch: UISwitch!

	@IBOutlet var patient_switch: UISwitch!

	@IBOutlet var section_switch: UISwitch!


	@IBOutlet var docu_switch: UISwitch!

	@IBOutlet var progressIndicator: UIActivityIndicatorView!

	@IBOutlet var cmdCreate: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		self.progressIndicator.stopAnimating()
		self.cmdCreate.isHidden = false
		self.progressIndicator.isHidden = true
	}
    
	@IBAction func create(_ sender: Any) {
		self.progressIndicator.isHidden = false
		self.cmdCreate.isHidden = true
		self.progressIndicator.startAnimating()

		let patientswitch = self.patient_switch.isOn
		let missionInfo = self.missionInfo_Switch.isOn
		let docu = self.docu_switch.isOn
		let section = self.section_switch.isOn

		DispatchQueue.global(qos: .background).async {
			let exportManager : Export = Export()
			let dataHandler : DataHandler = DataHandler()
			let mission : Mission = dataHandler.getMissionFromUnique(unique: (LoginHandler().getLoggedInUser()?.currentMissionUnique)!)!
			let url = exportManager.createExportPDF(mission: mission, Header: missionInfo, Patients: patientswitch, Sections: section, Docu: docu)


			DispatchQueue.main.async {
				let pdfViewer = self.storyboard?.instantiateViewController(withIdentifier: "ExportVC") as! ExportVC
				//pdfViewer.url = url.url
				pdfViewer.htmlText = url.html
				self.present(pdfViewer, animated: true, completion: nil)
			}
		}





	}

	func dismissMe(information : Any)
	{
		self.dismiss(animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
