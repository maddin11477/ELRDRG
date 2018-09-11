//
//  PatientenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenDetailVC: UIViewController, unitSelectedProtocol, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate{
    @IBOutlet weak var helicopterSwitch: UISwitch!
    
    @IBOutlet weak var shtSwitch: UISwitch!
    
    @IBOutlet weak var childSwitch: UISwitch!
    
    @IBOutlet weak var heatInjurySwitch: UISwitch!
    
    private var birthdatePicker : UIDatePicker?
    
    @IBOutlet weak var txtBirthdate: UITextField!
    
    @IBOutlet weak var txtTransportzielBottomConstrain: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == transportUnitTable)
        {
            return victim.fahrzeug?.allObjects.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            let unit = (victim.fahrzeug?.allObjects as! [Unit])[indexPath.row]
            victim.removeFromFahrzeug(unit)
            data.saveData()
            transportUnitTable.reloadData()
        }
    }
    
    @IBAction func addInjury_click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectInjury")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /* if(tableView == transportUnitTable)
        {
           
            
        }
        else
        {
            return nil
        }*/
        let cell = transportUnitTable.dequeueReusableCell(withIdentifier: "cell") as! UnitSelectCostumTableViewCell
        let units = victim.fahrzeug?.allObjects as! [Unit]
        let unit = units[indexPath.row]
        cell.Callsign.text = unit.callsign
        cell.crewCount.text = ""
        cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
        cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
        return cell
    }
    
    
    @IBOutlet weak var transportUnitTable: UITableView!
    
    
    func didSelectHospital(hospital: BaseHospital) {
        victim.hospital = hospitalData.BaseHospital_to_Hospital(baseHospital: hospital)
        victim.hospital?.addToVictim(victim)
        txtTransportDestination.text = (victim.hospital?.name)! + " / " + (victim.hospital?.city!)!
    }
    
    func didSelectUnit(unit: BaseUnit) {
        let fahrzeug = unitData.baseUnit_To_Unit(baseUnit: unit)
        victim.addToFahrzeug(fahrzeug)
       // unitData.baseUnit_To_Unit(baseUnit: unit)
        fahrzeug.patient = victim
        data.saveData()
        transportUnitTable.reloadData()
        
       
        
    }
    let hospitalData : HospitalHandler = HospitalHandler()
    let unitData : UnitHandler = UnitHandler()
    let data : DataHandler = DataHandler()
    let login : LoginHandler = LoginHandler()
    public var victim : Victim = Victim()
    
    
    
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var categoryPicker: UISegmentedControl!
    @IBOutlet weak var injuryTable: UITableView!
  
    @IBOutlet weak var txtTransportDestination: UITextField!
    
    @IBOutlet weak var lblTransportTime: UILabel!
    
    
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
        victim.category = Int16(categoryPicker.selectedSegmentIndex + 1)
        data.saveData()
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
        if(victim.hospital == nil && (txtTransportDestination.text?.count ?? 0) > 1)
        {
            let hospital = Hospital(context: AppDelegate.viewContext)
            hospital.name = txtTransportDestination.text!
            hospital.city = "unknown"
            victim.hospital = hospital
            data.saveData()
        }
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
        
        // Do any additional setup after loading the view.
        txtID.text = String(victim.id)
        txtAge.text = String(victim.age)
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
        categoryPicker.selectedSegmentIndex = Int(victim.category - 1 )
        txtTransportDestination.text = victim.hospital?.name
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
        
        birthdatePicker = UIDatePicker()
        txtBirthdate.inputView = birthdatePicker
        birthdatePicker?.datePickerMode = .date
        birthdatePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        
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
        self.view.endEditing(true)
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    

}
