//
//  CreateUnitVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class CreateUnitVC: UIViewController {

    
    public var basedata : BaseDataHandler?
    
    @IBOutlet weak var txtCrewCount: UITextField!
    
    @IBOutlet weak var CrewCountStepper: UIStepper!
    
    @IBOutlet weak var txtCallSign: UITextField!
    
    @IBOutlet weak var UnitPictureBox: UIImageView!
    
    @IBOutlet weak var UnitTypePicker: UISegmentedControl!
  
    
    
    @IBAction func UITypePicker_Changed(_ sender: UISegmentedControl)
    {
        let data  = BaseDataHandler()
        UnitPictureBox.image = UIImage(named: data.BaseUnit_To_UnitTypeString(id: Int16(UnitTypePicker.selectedSegmentIndex)))
    }
    
    @IBAction func CrewCount_StepperValueChanged(_ sender: UIStepper)
    {
        txtCrewCount.text = String(Int(CrewCountStepper.value))
        
    }
    
    @IBAction func AddUnit_Click(_ sender: UIBarButtonItem)
    {
       
        basedata!.addBaseUnit(callsign: txtCallSign.text!, type: BaseDataHandler.UnitType(rawValue: Int16(UnitTypePicker.selectedSegmentIndex))!, crewCount: Int16(CrewCountStepper.value))
        basedata!.saveData()
        basedata!.delegate?.createdUnit()
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
