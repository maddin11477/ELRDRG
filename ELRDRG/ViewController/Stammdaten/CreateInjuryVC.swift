//
//  CreateInjuryVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class CreateInjuryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var location : Int = 0
    var category : Int = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0)
        {
            location = row
        }
        else
        {
            category = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0)
        {
            return InjuryHandler.locationArray.count
        }
        else
        {
            return 3
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0)
        {
            return InjuryHandler.locationArray[row]
        }
        else
        {
            return String(row + 1)
        }
    }
    
    
    

    var injuryData : InjuryHandler?
    
    @IBOutlet weak var InjuryLocationPicker: UIPickerView!
    
    @IBOutlet weak var txtInjuryName: UITextField!
    
    
    @IBAction func Add_Click(_ sender: Any)
    {
        injuryData!.addBaseInjury(diagnose: txtInjuryName.text!, location: InjuryHandler.locationArray[location], category: 1)
        injuryData!.delegate?.createdInjury()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Abort_Click(_ sender: Any)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        print("dismissing")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InjuryLocationPicker.dataSource = self
        self.InjuryLocationPicker.delegate = self
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
