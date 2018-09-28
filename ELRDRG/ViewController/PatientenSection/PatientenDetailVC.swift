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
        victim.addToVerletzung(injury)
        injuryData.saveData()
        injuryTable.reloadData()
        print("reloading")
    }
    
    @IBOutlet weak var helicopterSwitch: UISwitch!
    
    @IBOutlet weak var shtSwitch: UISwitch!
    
    @IBOutlet weak var childSwitch: UISwitch!
    
    @IBOutlet weak var heatInjurySwitch: UISwitch!
    
    private var birthdatePicker : UIDatePicker?
    
    private var toolBar : UIToolbar?
    
    @IBOutlet weak var txtBirthdate: UITextField!
    
    @IBOutlet weak var txtTransportzielBottomConstrain: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == transportUnitTable)
        {
            return victim.fahrzeug?.allObjects.count ?? 0
        }
        else if(tableView == injuryTable)
        {
            let i =  victim.verletzung?.allObjects.count ?? 0
            print(i)
            return i
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
        if(editingStyle == .delete)
        {
            let unit = (victim.fahrzeug?.allObjects as! [Unit])[indexPath.row]
            unit.patient = nil
            victim.removeFromFahrzeug(unit)
            data.saveData()
            transportUnitTable.reloadData()
        }
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
            let verletzung = (victim.verletzung?.allObjects[indexPath.row]) as! Injury
            cell.injurytext.text = (verletzung.diagnosis ?? " ") + " " + (verletzung.location?.description ?? " ")
            return cell
        }
    }
    
    
    @IBOutlet weak var transportUnitTable: UITableView!
    
    
    func didSelectHospital(hospital: BaseHospital) {
        victim.hospital = hospitalData.BaseHospital_to_Hospital(baseHospital: hospital)
        victim.hospital?.addToVictim(victim)
        txtTransportDestination.text = (victim.hospital?.name)! + " / " + (victim.hospital?.city!)!
        hospitalImage.isHidden = false
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
                        availableUnit.patient = victim
                        victim.addToFahrzeug(availableUnit)
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
        fahrzeug.patient = victim
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
        victim.isDone = Date()
        data.saveData()
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm / dd.MM.yyyy"
        lblTransportTime.text = formatter.string(from: victim.isDone!)
        
    }
    @IBAction func isChildSwitched(_ sender: Any)
    {
        victim.child = childSwitch.isOn
        data.saveData()
    }
    
    @IBAction func helicopterSwitched(_ sender: Any)
    {
        victim.helicopter = helicopterSwitch.isOn
        data.saveData()
    }
    
    @IBAction func heatInjurySwitched(_ sender: Any)
    {
        victim.heatInjury = heatInjurySwitch.isOn
        data.saveData()
    }
    
    @IBAction func shtswitched(_ sender: Any)
    {
        victim.sht = shtSwitch.isOn
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
    
    
    
    @IBAction func txtLastName_editingDidEnd(_ sender: Any)
    {
        victim.lastName = txtLastName.text
        data.saveData()
    }
    
    @IBAction func deleteDestination_Click(_ sender: Any)
    {
        victim.hospital = nil
        hospitalImage.isHidden = true
        data.saveData()
        txtTransportDestination.text = ""
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
        //categoryPicker.selectedSegmentIndex = Int(victim.category - 1 )
        
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
        heatInjurySwitch.isOn = victim.heatInjury
        shtSwitch.isOn = victim.sht
        helicopterSwitch.isOn = victim.helicopter
        
        
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
        birthdatePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        
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
        
        //self.view.endEditing(true)
    }
  
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    

}
