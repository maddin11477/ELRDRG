//
//  PatientenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenDetailVC: UIViewController, unitSelectedProtocol {
    func didSelectUnit(unit: BaseUnit) {
        
        victim.fahrzeug = unitData.baseUnit_To_Unit(baseUnit: unit)
        victim.fahrzeug?.patient = victim
        data.saveData()
        txtTransportUnit.text = victim.fahrzeug?.callsign ?? ""
    }
    
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
    @IBOutlet weak var txtTransportUnit: UITextField!
    @IBOutlet weak var txtTransportDestination: UITextField!
    
    @IBOutlet weak var lblTransportTime: UILabel!
    
    
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var idStepper: UIStepper!
    
    @IBAction func startTransport_Click(_ sender: Any)
    {
        victim.isDone = Date()
        data.saveData()
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "hh:mm / dd.MM.yyyy"
        lblTransportTime.text = formatter.string(from: victim.isDone!)
        
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
        
    }
    
    @IBAction func chooseTransportUnit_Click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectUnitVC") as! SelectUnitVC
        vc.delegate = self
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
        
        // Do any additional setup after loading the view.
        txtID.text = String(victim.id)
        txtAge.text = String(victim.age)
        txtLastName.text = victim.lastName
        txtFirstName.text = victim.firstName
        txtTransportUnit.text = victim.fahrzeug?.callsign
        categoryPicker.selectedSegmentIndex = Int(victim.category - 1 )
        txtTransportDestination.text = victim.hospital?.name
        idStepper.value = Double(victim.id)
        ageStepper.value = Double(victim.age)
        genderPicker.selectedSegmentIndex = Int(victim.gender)
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "hh:mm / dd.MM.yyyy"
        if let date = victim.isDone
        {
            lblTransportTime.text = formatter.string(from: date)
        }
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    

}
