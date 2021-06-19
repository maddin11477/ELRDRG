//
//  CreateUnitVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
public protocol UnitExtention
{
    func createdUnit(unit : BaseUnit)
    
}
class CreateUnitVC: UIViewController {

    
    var unitdata : UnitHandler?
    var hospitalData : HospitalHandler?
    var injuryData : InjuryHandler?
    
    @IBOutlet weak var txtCrewCount: UITextField!
    
    @IBOutlet weak var CrewCountStepper: UIStepper!
    
    @IBOutlet weak var txtCallSign: UITextField!
    
    @IBOutlet weak var UnitPictureBox: UIImageView!
    
    @IBOutlet weak var UnitTypePicker: UISegmentedControl!
  
    
    public var delegate : UnitExtention?
    
    @IBAction func UITypePicker_Changed(_ sender: UISegmentedControl)
    {
        let data  = UnitHandler()
        UnitPictureBox.image = UIImage(named: data.BaseUnit_To_UnitTypeString(id: Int16(UnitTypePicker.selectedSegmentIndex)))
    }
    
    @IBAction func CrewCount_StepperValueChanged(_ sender: UIStepper)
    {
        txtCrewCount.text = String(Int(CrewCountStepper.value))
        
    }
    
    @IBAction func AddUnit_Click(_ sender: UIBarButtonItem)
    {
        if(self.unitdata == nil)
        {
            unitdata = UnitHandler()
        }
        
        
        
        
        let unit = self.unitdata!.addBaseUnit(callsign: txtCallSign.text!, type: UnitHandler.UnitType(rawValue: Int16(UnitTypePicker.selectedSegmentIndex))!, crewCount: Int16(CrewCountStepper.value))
        unit.tempBaseUnit = !SettingsHandler().getSettings().safedynCreatedUnit
        self.unitdata!.saveData()
       
        
        if let del = self.unitdata?.delegate
        {
            del.createdUnit()
        }
        if let localDel = self.delegate
        {
            localDel.createdUnit(unit : unit)
        }
      
        
        //self.delegate!.createdUnit(unit: unit)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        print("dismissing")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCrewCount.text = "1"
        CrewCountStepper.value = 1
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
