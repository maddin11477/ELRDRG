//
//  ChangeMissionVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.01.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

protocol changedMissionDelegate {
	func didEndEditingMission()
}

class ChangeMissionVC: UIViewController {

	var mission : Mission?

	@IBOutlet var HeaderImage: UIImageView!

	@IBOutlet var IDheadline: UILabel!

	@IBOutlet var txtBezeichnung: UITextField!

	@IBOutlet var txtOrt: UITextField!

	@IBOutlet var lblStartZeit: UILabel!

	@IBOutlet var lblEndZeit: UILabel!

	@IBOutlet var cmd_endMission: UIButton!


	public var delegate : changedMissionDelegate?

	@IBAction func EndMission_click(_ sender: Any) {
		let alertController = UIAlertController(title: "Einsatz beenden?", message: "Sicher, dass Sie den Einsatz abschließen möchten? Änderungen können anschließend nicht rückgängig gemacht werden!", preferredStyle: .alert)
		let actionController = UIAlertAction(title: "Nein", style: .default, handler: nil)
		let actionController1 = UIAlertAction(title: "Beenden", style: .destructive, handler: self.endMission)
		alertController.addAction(actionController)
		alertController.addAction(actionController1)
		self.present(alertController, animated: true, completion: nil)


	}


	func endMission(sender : Any)
	{
		if let einsatz = self.mission
		{
			self.HeaderImage.image = UIImage(systemName: "checkmark.circle.fill")
			self.HeaderImage.tintColor = UIColor.green

			einsatz.isFinished = true
			if einsatz.end == nil
			{
				einsatz.end = Date()
				let formatter = DateFormatter()
				formatter.dateFormat = "dd.MM.yyyy - HH:mm"
				lblEndZeit.text = formatter.string(from: einsatz.end!) + " Uhr"
			}
			self.cmd_endMission.isHidden = true


			DataHandler().saveData()
		}
	}

	@IBAction func deleteMission_click(_ sender: Any) {
		let alertcontroller = UIAlertController(title: "Löschen", message: "Diese Funktion steht noch nicht zur Verfügung", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alertcontroller.addAction(action)
		self.present(alertcontroller, animated: true, completion: nil)
	}


	@IBAction func saveMission_click(_ sender: Any) {
		if let einsatz = self.mission
		{
			einsatz.location = txtOrt.text
			einsatz.reason = txtBezeichnung.text
			DataHandler().saveData()
		}
		if let del = self.delegate
		{
			del.didEndEditingMission()
		}
		self.dismiss(animated: true, completion: nil)
	}





    override func viewDidLoad() {
        super.viewDidLoad()
		if let einsatz = self.mission
		{
			self.txtOrt.text = einsatz.location ?? ""
			self.txtBezeichnung.text = einsatz.reason ?? ""
			self.IDheadline.text = "Einsatz ID: " //+ String(describing: einsatz.id)
			let formatter = DateFormatter()
			formatter.dateFormat = "dd.MM.yyyy - HH:mm"
			if let date = einsatz.start
			{
				self.lblStartZeit.text = formatter.string(from: date) + " Uhr"
			}
			else
			{
				self.lblStartZeit.text = ""
			}
			if let date = einsatz.end
			{
				self.lblEndZeit.text = formatter.string(from: date) + " Uhr"
			}
			else
			{
				self.lblEndZeit.text = ""
			}


			if einsatz.isFinished
			{
				self.HeaderImage.image = UIImage(systemName: "checkmark.circle.fill")
				self.HeaderImage.tintColor = UIColor.green
				self.cmd_endMission.isHidden = true


			}
		}
       
    }
    



}
