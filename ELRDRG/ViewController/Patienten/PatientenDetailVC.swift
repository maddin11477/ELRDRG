//
//  PatientenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenDetailVC: UIViewController, unitSelectedProtocol, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, InjurySelectionProtocol{
    func selectedInjury(injury: Injury) {
        
        
        injury.patient = victim
		if injury.location == "Kopf"
		{

		}
        victim.addToVerletzung(injury)
        injuryData.saveData()
        injuryTable.reloadData()
        print("reloading")
    }

	@IBAction func additionalInfoChanged(_ sender: Any) {
		self.victim.additionalIfnormation = lbl_additionalInfo.text
		data.saveData()
	}





	func checkDoublePatID()
	{
		let victims = DataHandler().getVictims()
		var isDouble = false
		for vic in victims {
			if (vic != self.victim && vic.id == victim.id)
			{
				isDouble = true
				break
			}
		}

		lblDoublePatID.isHidden = !isDouble
	}
    
    


	@IBAction func IDChanged(_ sender: Any) {
		let newID = Int16(txtID.text ?? "-100")
		if (Int(newID ?? -100) > -100 && newID != self.victim.id)
		{
			self.victim.id = newID ?? Int16(self.victim.id)
			checkDoublePatID()
			DataHandler().saveData()
		}

	}


	@IBAction func txt_Age_Edit_ended(_ sender: Any) {
		if let s_Age = txtAge.text
		{
			if let age = Int16(s_Age)
			{
				self.victim.age = age
				if let birthday = self.victim.birthdate
				{
					let formatter = DateFormatter()
					formatter.dateFormat = "dd.MM.yyyy"
					self.victim.birthdate = setAge(age: Int(age), date: birthday)
					self.txtBirthdate.text = formatter.string(from: self.victim.birthdate ?? birthday)
					data.saveData()
				}
			}

		}
	}

	@IBOutlet var lblDoublePatID: UILabel!


	func setAge(age : Int, date : Date)->Date
	{
		let calender = Calendar.current
		var components : DateComponents = calender.dateComponents([.day, .month, .year], from: date)
		if let currentYear = calender.dateComponents([.year], from: Date()).year
		{
			components.year = currentYear - age
			return calender.date(from: components) ?? date
		}
		return date
	}
	@IBOutlet var cmdStartStoppTransport: UIButton!

    
    @IBOutlet weak var helicopterSwitch: UISwitch!
    
    @IBOutlet weak var shtSwitch: UISwitch!
    
    @IBOutlet weak var childSwitch: UISwitch!
    
    @IBOutlet weak var heatInjurySwitch: UISwitch!

	@IBOutlet var lblHandledByUnit: UILabel!

	@IBOutlet var cmdAddUnit: UIButton!


    private var birthdatePicker : UIDatePicker?
    
    private var toolBar : UIToolbar?
    
    @IBOutlet weak var txtBirthdate: UITextField!
    
    @IBOutlet var hospitalInfoStateControl: UISegmentedControl!

    @IBOutlet weak var txtTransportzielBottomConstrain: NSLayoutConstraint!

	@IBOutlet var cmdUnitLeave: RoundButton!

	@IBOutlet var lbl_additionalInfo: UITextField!

    @IBOutlet weak var patILSNR: UITextField!
    


	@IBAction func unitsLeave(_ sender: Any) {
		if cmdUnitLeave.title(for: .normal) == "Entlassen"
		{
			let units = victim.fahrzeug?.allObjects as! [Unit]
			var text = ""
			var i = 0
			for unit in units
			{
				text = text + (unit.callsign ?? "")
				if(i<units.count - 1)
				{
					text = text + "\n"
				}
				deleteUnit(index: 0)
				i = i + 1
			}
			victim.handledUnit = text
			victim.isDone = Date()
			let formatter : DateFormatter = DateFormatter()
			formatter.dateFormat = "dd.MM.yyyy"// um HH:mm"
			let s_date = formatter.string(from: victim.isDone!)
			formatter.dateFormat = "hh:mm"
			text = "Durch folgende Einheit versorgt:\n\n" + text
			lblHandledByUnit.text = text
			let s_time = formatter.string(from: victim.isDone!)

			//text = text + "\n\n Entlassen am \(s_date) um \(s_time) Uhr"
			text = s_time +  " / " + s_date + "(entlassen)"
			lblTransportTime.text = text
			data.saveData()
			if let _ = victim.hospital
			{
				let controller = UIAlertController(title: "Transportziel", message: "Soll das Transportziel entfernt werden?", preferredStyle: .alert)
				let yes = UIAlertAction(title: "JA", style: .default, handler: { action in
					self.victim.hospital = nil
					self.data.saveData()
					self.hospitalInfoStateControl.selectedSegmentIndex = 0
					self.hospitalInfoStateControl.isHidden = true
					self.txtTransportDestination.text = ""
					self.hospitalImage.isHidden = true

				})
				let NO = UIAlertAction(title: "NEIN", style: .cancel, handler: nil)
				controller.addAction(yes)
				controller.addAction(NO)
				self.present(controller, animated: true, completion: nil)
			}





			//SET UI
			transportUnitTable.isHidden = true
			lblHandledByUnit.isHidden = false

			cmdStartStoppTransport.isHidden = true
			cmdUnitLeave.setTitle("Löschen", for: .normal)
			cmdUnitLeave.borderColor = UIColor.red
			cmdUnitLeave.tintColor = UIColor.red
			cmdAddUnit.isHidden = true



		}
		else
		{
			victim.handledUnit = nil
			transportUnitTable.isHidden = false
			lblHandledByUnit.isHidden = true
			lblHandledByUnit.text = ""
			cmdStartStoppTransport.isHidden = false
			cmdStartStoppTransport.setTitle("Transportbeginn", for: .normal)
			cmdUnitLeave.setTitle("Entlassen", for: .normal)
			cmdUnitLeave.borderColor = cmdAddUnit.backgroundColor ?? UIColor.gray
			cmdUnitLeave.tintColor = cmdAddUnit.backgroundColor ?? UIColor.gray
			cmdAddUnit.isHidden = false
			victim.isDone = nil
			lblTransportTime.text = ""
			self.data.saveData()

		}



	}

	var injuries : [Injury] = []
    @IBAction func hospitalInfoStateChanged(_ sender: Any) {
        self.victim.setHospitalInfoState(hospitalState: (sender as! UISegmentedControl).selectedSegmentIndex)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == transportUnitTable)
        {
             let i = victim.fahrzeug?.allObjects.count ?? 0
			if i == 0
			{
				cmdStartStoppTransport.isHidden = true
			}
			else if (i > 0 && victim.handledUnit == nil)
			{
				cmdStartStoppTransport.isHidden = false
			}
			return i
        }
        else if(tableView == injuryTable)
        {
			self.injuries = victim.verletzung?.allObjects as! [Injury]
			self.injuries.sort {$0.category > $1.category }


			return injuries.count
        }
        print(tableView)
        return 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(tableView == injuryTable)
        {
            injuryData.deleteInjury(injury: (victim.verletzung?.allObjects as! [Injury])[indexPath.row])
            injuryTable.reloadData()
            return
        }
		//transportUnitTable - Transport Unit Table
        if(editingStyle == .delete)
        {
			deleteUnit(index: indexPath.row)
        }
    }

	func deleteUnit(index : Int)
	{
		let unit = (victim.fahrzeug?.allObjects as! [Unit])[index]
		unit.removeFromPatient(self.victim)
		victim.removeFromFahrzeug(unit)
		if victim.fahrzeug!.allObjects.count < 1
		{
			victim.section = unit.section
			victim.section?.addToVictims(self.victim)
		}

		data.saveData()
		transportUnitTable.reloadData()

	}
    
    @IBAction func addInjury_click(_ sender: Any)
    {
        let tabbarcontroller = self.storyboard?.instantiateViewController(withIdentifier: "SelectInjury") as! InjuryTC
        
        let vc = tabbarcontroller.viewControllers![1] as! SelectInjuryTableVC
        vc.delegate = self
        //InjuryHandler.injuryDelegate = self
        self.present(tabbarcontroller, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if(tableView == transportUnitTable)
        {
        let cell = transportUnitTable.dequeueReusableCell(withIdentifier: "cell") as! UnitSelectCostumTableViewCell
        let units = victim.fahrzeug?.allObjects as! [Unit]
        let unit = units[indexPath.row]
        cell.Callsign.text = unit.callsign
        cell.crewCount.text = ""
        cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
        cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
        return cell
        }
        else
        {
            let cell = injuryTable.dequeueReusableCell(withIdentifier: "smallinjurycell") as! smallinjurycell
			let verletzung = self.injuries[indexPath.row]
            cell.injurytext.text = (verletzung.diagnosis ?? " ")
			cell.lbl_location.text = verletzung.location
            return cell
        }
    }
    
    
    @IBOutlet weak var transportUnitTable: UITableView!
    
    
    func didSelectHospital(hospital: BaseHospital)
	{
        victim.hospital = hospitalData.BaseHospital_to_Hospital(baseHospital: hospital)
        victim.hospital?.addToVictim(victim)
        txtTransportDestination.text = (victim.hospital?.name)! + " / " + (victim.hospital?.city!)!
        hospitalImage.isHidden = false
		hospitalInfoStateControl.isHidden = false
    }


    
    func didSelectUnit(unit: BaseUnit) {
        var isAvailable : Bool = false
        let data = SectionHandler()
        for section in data.getSections() {
            if let units = section.units?.allObjects as? [Unit]
            {
                for availableUnit in units
                {
                    if(availableUnit.callsign == unit.funkrufName && availableUnit.type == unit.type)
                    {
                        
                        //availableUnit.patient = victim
                        availableUnit.addToPatient(victim)
                        victim.addToFahrzeug(availableUnit)
						if let sec = victim.section
						{
							sec.addToUnits(availableUnit)
							availableUnit.section = sec
						}
						victim.section = nil
                        isAvailable = true
                        
                    }
                }
            }
            
        }
        if(isAvailable == true)
        {
            data.saveData()
            transportUnitTable.reloadData()
            return
        }
        let fahrzeug = unitData.baseUnit_To_Unit(baseUnit: unit)
        victim.addToFahrzeug(fahrzeug)
       // unitData.baseUnit_To_Unit(baseUnit: unit)
        fahrzeug.addToPatient(victim)
		if let sec = victim.section
		{
			sec.addToUnits(fahrzeug)
			fahrzeug.section = sec
		}
		victim.section = nil
        data.saveData()
        transportUnitTable.reloadData()
        
       
        
    }

	func didselectUsedUnit(unit: Unit) {
		//Adding current patient to selected usedUnit
		let data = SectionHandler()
		unit.addToPatient(self.victim)
		victim.addToFahrzeug(unit)
		if let sec = victim.section
		{
			sec.addToUnits(unit)
			unit.section = sec
		}
		victim.section = nil
		data.saveData()
		transportUnitTable.reloadData()
	}





    let hospitalData : HospitalHandler = HospitalHandler()
    let unitData : UnitHandler = UnitHandler()
    let injuryData : InjuryHandler = InjuryHandler()
    let data : DataHandler = DataHandler()
    let login : LoginHandler = LoginHandler()
    public var victim : Victim = Victim()
    
    
    
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var categoryPicker: CategorySegmentedControl!
    @IBOutlet weak var injuryTable: UITableView!
  
    
    @IBOutlet weak var txtTransportDestination: UILabel!
    
    @IBOutlet weak var lblTransportTime: UILabel!
    
    @IBOutlet weak var hospitalImage: UIImageView!
    
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var idStepper: UIStepper!
    
    @IBAction func startTransport_Click(_ sender: Any)
    {
		let button = sender as! UIButton
		if let _ = victim.isDone
		{

			button.setTitle("Transportbeginn", for: .normal)
			victim.isDone = nil
			lblTransportTime.text = ""
		}
        else
		{
			victim.isDone = Date()
			data.saveData()
			let formatter : DateFormatter = DateFormatter()
			formatter.dateFormat = "HH:mm / dd.MM.yyyy"
			lblTransportTime.text = formatter.string(from: victim.isDone!)
			button.setTitle("Trp. zurücksetzen", for: .normal)
		}
        
    }
    @IBAction func isChildSwitched(_ sender: Any)
    {
        victim.child = childSwitch.isOn
        data.saveData()
    }
    
    @IBAction func helicopterSwitched(_ sender: Any)
    {
		victim.intubiert = helicopterSwitch.isOn
        data.saveData()
    }
    
    @IBAction func heatInjurySwitched(_ sender: Any)
    {
        victim.schockraum = heatInjurySwitch.isOn
        data.saveData()
    }
    
    @IBAction func shtswitched(_ sender: Any)
    {
        victim.stabil = shtSwitch.isOn
        data.saveData()
    }
    
    @IBAction func AddInjury_Click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectInjury")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func txtFirstName_editingDidEnd(_ sender: Any)
    {
        victim.firstName = txtFirstName.text
        data.saveData()
    }
    
    @IBAction func ILNR_didEndEditing(_ sender: Any) {
        victim.patILSNR = patILSNR.text ?? ""
        data.saveData()
    }
    
    
    @IBAction func txtLastName_editingDidEnd(_ sender: Any)
    {
        victim.lastName = txtLastName.text
        data.saveData()
    }
    
    @IBAction func deleteDestination_Click(_ sender: Any)
    {
        victim.hospital = nil
        victim.setHospitalInfoState(hospitalState: 0)
        hospitalImage.isHidden = true
        data.saveData()
        txtTransportDestination.text = ""
		hospitalInfoStateControl.isHidden = true
		hospitalInfoStateControl.selectedSegmentIndex = 0
		
    }
    
    @IBAction func chooseTrransportDestination(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectUnitVC") as! SelectUnitVC
        vc.delegate = self
        vc.type = .hospitalselector
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func chooseTransportUnit_Click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectUnitVC") as! SelectUnitVC
        vc.delegate = self
        vc.type = .unitselector
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func category_changed(_ sender: Any)
    {
        
        let control = sender as! CategorySegmentedControl
        
        if(control.selectedSegmentIndex != UISegmentedControlNoSegment && control.selectedSegmentIndex > -1)
        {
            victim.category = Int16(control.selectedSegmentIndex + 1)
            control.changeSelectedIndex(to: control.selectedSegmentIndex)
            data.saveData()
        }
        
    }
    
    
    @IBAction func gender_changed(_ sender: Any)
    {
        victim.gender = Int16(genderPicker.selectedSegmentIndex)
        data.saveData()
    }
    
    @IBAction func ageStepper_Click(_ sender: Any)
    {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        victim.age = Int16(ageStepper.value)
        if let date = victim.birthdate
        {
        let calender = Calendar.current
        var datecomponents = DateComponents()
        var year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)
        let day = calender.component(.day, from: date)
        let now = Date()
        let currentYear = Calendar.current.component(.year, from: now)
        year = currentYear - Int(ageStepper.value)
         print(Int(ageStepper.value))
         print(year)
        datecomponents.year = year
        datecomponents.day = day
        datecomponents.month = month
        
        
        
        let newDate = gregorianCalendar.date(from: datecomponents) ?? Date()
            victim.birthdate = newDate
            data.saveData()
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            txtBirthdate.text = formatter.string(from: newDate)
        }
        if(victim.age < 18)
        {
            childSwitch.isOn = true
            victim.child = true
            data.saveData()
        }
        else
        {
            childSwitch.isOn = false
            victim.child = false
            data.saveData()
        }
        txtAge.text = String(victim.age)
    }
    
    
    @IBAction func iDStepper_Click(_ sender: Any)
    {
        victim.id = Int16(idStepper.value)
        data.saveData()
        txtID.text = String(Int16(idStepper.value))
		checkDoublePatID()
        
    }
    
    
    @IBAction func closeViewController_Click(_ sender: Any)
    {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func calculateAge(date : Date) -> Int
    {
        let now = Date()
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        let ageComponents = calendar.components(.year, from: victim.birthdate!, to: now as Date, options: [])
        let age = ageComponents.year!
        return age
    }
    
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transportUnitTable.delegate = self
        transportUnitTable.dataSource = self
        injuryTable.delegate = self
        
        injuryTable.dataSource = self
        // Do any additional setup after loading the view.
        txtID.text = String(victim.id)
        txtAge.text = String(victim.age)
        patILSNR.text = victim.patILSNR ?? ""
        if(victim.age == -1)
        {
            txtAge.text = ""
        }
        txtLastName.text = victim.lastName
        txtFirstName.text = victim.firstName
        if let birthdate = victim.birthdate
        {
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            txtBirthdate.text = formatter.string(from: birthdate)
           let age = calculateAge(date: victim.birthdate!)
            txtAge.text = String(age)
            ageStepper.value = Double(age)
            
        }
       
        
        transportUnitTable.reloadData()
       
        
        categoryPicker.changeSelectedIndex(to: Int(victim.category - 1))
        if let hospital = victim.hospital
        {
            txtTransportDestination.text = hospital.name! + " / " + hospital.city!
            hospitalImage.isHidden = false
        }
        else
        {
            hospitalImage.isHidden = true
        }
       
        idStepper.value = Double(victim.id)
        ageStepper.value = Double(victim.age)
        genderPicker.selectedSegmentIndex = Int(victim.gender)
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm / dd.MM.yyyy"
        if let date = victim.isDone
        {
            lblTransportTime.text = formatter.string(from: date)
        }
        
        childSwitch.isOn = victim.child
        heatInjurySwitch.isOn = victim.schockraum
        shtSwitch.isOn = victim.stabil
        helicopterSwitch.isOn = victim.intubiert
        
        
        toolBar = UIToolbar()
        toolBar!.barStyle = UIBarStyle.default
        toolBar!.isTranslucent = false
        //toolBar!.tintColor = UIColor(red: 52, green: 120, blue: 246, alpha: 1)
        toolBar!.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Fertig", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneButtonAction))
        
       
        toolBar!.setItems([doneButton], animated: false)
        toolBar!.isUserInteractionEnabled = true
        
        birthdatePicker = UIDatePicker()
        
        if let date = victim.birthdate
        {
            birthdatePicker?.date = date
            
        }
        
        txtBirthdate.inputView = birthdatePicker
        txtBirthdate.inputAccessoryView = toolBar
        birthdatePicker?.datePickerMode = .date
        let loc = Locale(identifier: "Ger")
        birthdatePicker?.locale = loc
        birthdatePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        if #available(iOS 14, *) {
            birthdatePicker?.preferredDatePickerStyle = .wheels
            }
        hospitalInfoStateControl.selectedSegmentIndex = self.victim.getHospitalInfoState()
        if let _ = victim.hospital
        {
            hospitalInfoStateControl.isHidden = false
        }
        else
        {
            hospitalInfoStateControl.isHidden = true
        }
		checkDoublePatID()
		if let _ = self.victim.isDone
		{
			cmdStartStoppTransport.setTitle("Trp. zurücksetzen", for: .normal)
		}
		else
		{
			cmdStartStoppTransport.setTitle("Transportbeginn", for: .normal)
		}

		if let info = self.victim.additionalIfnormation
		{
			lbl_additionalInfo.text = info
		}


		if let text = victim.handledUnit
		{
			let s_text = "Durch folgende Einheiten versorgt:\n\n" + text
			lblTransportTime.text = (lblTransportTime.text ?? "") + "(entlassen)"



			transportUnitTable.isHidden = true
			lblHandledByUnit.isHidden = false
			lblHandledByUnit.text = s_text
			cmdStartStoppTransport.isHidden = true
			cmdUnitLeave.setTitle("Löschen", for: .normal)
			cmdUnitLeave.borderColor = UIColor.red
			cmdUnitLeave.tintColor = UIColor.red
			cmdAddUnit.isHidden = true

		}
		else
		{
			victim.handledUnit = nil
			transportUnitTable.isHidden = false
			lblHandledByUnit.isHidden = true
			lblHandledByUnit.text = ""
			cmdStartStoppTransport.isHidden = false
			cmdUnitLeave.setTitle("Entlassen", for: .normal)
			cmdUnitLeave.borderColor = cmdAddUnit.backgroundColor ?? UIColor.gray
			cmdUnitLeave.tintColor = cmdAddUnit.backgroundColor ?? UIColor.gray
			cmdAddUnit.isHidden = false

		}
        
    }
    
    @objc func doneButtonAction()
    {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        txtBirthdate.text = formatter.string(from: (self.birthdatePicker?.date)!)
        victim.birthdate = self.birthdatePicker?.date
        ageStepper.value = Double(calculateAge(date: victim.birthdate!))
        victim.age = Int16(ageStepper.value)
        data.saveData()
        txtAge.text = String(Int(ageStepper.value))
        
        
    }

}
