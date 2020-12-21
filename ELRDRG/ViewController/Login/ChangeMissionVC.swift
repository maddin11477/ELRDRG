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

class ChangeMissionVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StatisticHandler.MissionType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StatisticHandler.MissionType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let mission = self.mission
        {
            mission.missionType = StatisticHandler.MissionType.allCases[row].rawValue
            DataHandler().saveData()
        }
        
    }

	var mission : Mission?
	var id : Int?

	@IBOutlet var HeaderImage: UIImageView!

	@IBOutlet var IDheadline: UILabel!

	@IBOutlet var txtBezeichnung: UITextField!

	@IBOutlet var txtOrt: UITextField!

	@IBOutlet var lblStartZeit: UILabel!

	@IBOutlet var lblEndZeit: UILabel!

	@IBOutlet var cmd_endMission: UIButton!

	@IBOutlet var startTimePicker: UIDatePicker!

	@IBOutlet var endTimePicker: UIDatePicker!

	@IBOutlet var txtStartKm: UITextField!

	@IBOutlet var txtEndKm: UITextField!
    
    func setupInputViews()
    {
        if let einsatz = self.mission
        {
            self.lblEndZeit.isEnabled = !einsatz.isFinished
            self.lblStartZeit.isEnabled = !einsatz.isFinished
            self.endTimePicker.isEnabled = !einsatz.isFinished
            self.startTimePicker.isEnabled = !einsatz.isFinished
            self.txtStartKm.isEnabled = !einsatz.isFinished
            self.txtEndKm.isEnabled = !einsatz.isFinished
            self.txtOrt.isEnabled = !einsatz.isFinished
            self.txtBezeichnung.isEnabled = !einsatz.isFinished
            self.IDheadline.isEnabled = !einsatz.isFinished
        }
        
    }
    
    
    @IBOutlet weak var missionTypePickerView: UIPickerView!
    

	@IBAction func startTimeChanged(_ sender: Any) {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy - HH:mm"

		mission?.start = startTimePicker.date
		lblStartZeit.text = formatter.string(from: startTimePicker.date) + " Uhr"
	}

	@IBAction func endTimeChanged(_ sender: Any) {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy - HH:mm"
		mission?.end = endTimePicker.date

		lblEndZeit.text = formatter.string(from: endTimePicker.date) + " Uhr"



	}


	public var delegate : changedMissionDelegate?

	@IBAction func EndMission_click(_ sender: Any) {
        if let mission = self.mission
        {
            if mission.isFinished
            {
                let alertController = UIAlertController(title: "Einsatz erneut öffnen?", message: "Sicher, dass Sie den Einsatz öffnen möchten?", preferredStyle: .alert)
                let actionController = UIAlertAction(title: "Nein", style: .default, handler: nil)
                let actionController1 = UIAlertAction(title: "Öffnen", style: .destructive, handler: self.openMission)
                alertController.addAction(actionController)
                alertController.addAction(actionController1)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
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
            self.cmd_endMission.isHidden = false
            self.cmd_endMission.setTitle("Einsatz öffnen", for: .normal)
            einsatz.endMission()
            endTimePicker.setDate(einsatz.end!, animated: true)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:mm"
            lblEndZeit.text = formatter.string(from: einsatz.end!) + " Uhr"
            missionTypePickerView.isUserInteractionEnabled = false
            self.setupInputViews()
		}
	}
    
    func openMission(sender : Any)
    {
        if let mission = self.mission
        {
            self.HeaderImage.image = UIImage(systemName: "folder.circle.fill")
            self.HeaderImage.tintColor = UIColor.gray
            self.cmd_endMission.isHidden = false
            self.cmd_endMission.setTitle("Einsatz beenden", for: .normal)
            mission.reOpen()
            self.setupInputViews()
        }
    }

	@IBAction func deleteMission_click(_ sender: Any) {
		let alertcontroller = UIAlertController(title: "Löschen", message: "Sind Sie sicher, dass Sie diesen Einsatz unwiederruflich löschen möchten?", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: self.deleteMission)
		alertcontroller.addAction(action)
		let abort = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
		alertcontroller.addAction(abort)
		self.present(alertcontroller, animated: true, completion: nil)
	}

	func deleteMission(information : Any)
	{
		if let einsatz = self.mission
		{
			DataHandler().deleteMission(mission: einsatz)
			self.delegate?.didEndEditingMission()
			self.dismiss(animated: true, completion: nil)
		}

	}

	@IBAction func saveMission_click(_ sender: Any) {
		if let einsatz = self.mission
		{
			einsatz.location = txtOrt.text
			einsatz.reason = txtBezeichnung.text
			einsatz.missionTaskNumber = Int32(txtAuftragsnummer.text ?? "") ?? -1
			einsatz.startKm = txtStartKm.text
			einsatz.endKm = txtEndKm.text
			DataHandler().saveData()
		}
		if let del = self.delegate
		{
			del.didEndEditingMission()
		}
		self.dismiss(animated: true, completion: nil)
	}

	@IBOutlet var txtAuftragsnummer: UITextField!


	@IBAction func didEndEditingAuftragsnummer(_ sender: Any) {
		var auftragsnummer = -1
		if let text = txtAuftragsnummer.text
		{
			if text.count > 0
			{
				auftragsnummer = Int(txtAuftragsnummer.text ?? "") ?? -1
				if(auftragsnummer == -1)
				{
					let Controller = UIAlertController(title: "Fehler", message: "Auftragsnummer konnte nicht gespeichert werden. Es dürfen nur Zahlen eingegeben werden!", preferredStyle: .alert)
					let action = UIAlertAction(title: "OK", style: .default, handler: nil)
					Controller.addAction(action)
					self.present(Controller, animated: true, completion: nil)
					txtAuftragsnummer.text = ""
				}
			}

		}

	}
    
    func loadPickerView()
    {
        if let einsatz = self.mission
        {
            //self.missionTypePickerView.reloadAllComponents()
            let missionType = StatisticHandler.MissionType.init(rawValue: einsatz.missionType ?? StatisticHandler.MissionType.allCases[0].rawValue)
            var row = -1
            if let type = missionType
            {
                row = StatisticHandler.MissionType.allCases.index(of: type) ?? 0
            }
            else
            {
                row = 0
            }
            
            self.missionTypePickerView.selectRow(row, inComponent: 0, animated: false)
        }
        
    }
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
       
		if let einsatz = self.mission
		{
			self.txtOrt.text = einsatz.location ?? ""
			self.txtBezeichnung.text = einsatz.reason ?? ""
			self.IDheadline.text = "Einsatz ID: " + String(self.id ?? -1)
            self.missionTypePickerView.delegate = self
            self.missionTypePickerView.dataSource = self
            loadPickerView()
			if einsatz.missionTaskNumber > 0
			{
				txtAuftragsnummer.text = String(einsatz.missionTaskNumber)
			}
			else
			{
				txtAuftragsnummer.text = ""
			}

			let formatter = DateFormatter()
			formatter.dateFormat = "dd.MM.yyyy - HH:mm"
			if let date = einsatz.start
			{
				self.lblStartZeit.text = formatter.string(from: date) + " Uhr"
				self.startTimePicker.setDate(date, animated: true)
			}
			else
			{
				self.lblStartZeit.text = ""
			}
			if let date = einsatz.end
			{
				self.lblEndZeit.text = formatter.string(from: date) + " Uhr"
				self.endTimePicker.setDate(date, animated: true)
			}
			else
			{
				self.lblEndZeit.text = ""
			}


			if einsatz.isFinished
			{
				self.HeaderImage.image = UIImage(systemName: "checkmark.circle.fill")
				self.HeaderImage.tintColor = UIColor.green
				self.cmd_endMission.isHidden = false
                
			}
            
            self.cmd_endMission.setTitle(einsatz.isFinished ? "Einsatz öffnen":"Einsatz beenden", for: .normal)
            

			txtStartKm.text = einsatz.startKm
			txtEndKm.text = einsatz.endKm
            self.setupInputViews()
            
            
		}
       
    }
    



}