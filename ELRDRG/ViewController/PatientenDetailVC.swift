//
//  PatientenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenDetailVC: UIViewController, unitSelectedProtocol, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var helicopterSwitch: UISwitch!
    
    @IBOutlet weak var shtSwitch: UISwitch!
    
    @IBOutlet weak var childSwitch: UISwitch!
    
    @IBOutlet weak var heatInjurySwitch: UISwitch!
    
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
    
    @IBAction func addInjury_click(_ sender: UIBarButtonItem)
    {
        
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
        victim.age = Int16(ageStepper.value)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transportUnitTable.delegate = self
        transportUnitTable.dataSource = self
        
        // Do any additional setup after loading the view.
        txtID.text = String(victim.id)
        txtAge.text = String(victim.age)
        txtLastName.text = victim.lastName
        txtFirstName.text = victim.firstName
       
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
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    

}
