//
//  SelectUnitVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 09.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol unitSelectedProtocol {
    func didSelectUnit(unit : BaseUnit)
    func didSelectHospital(hospital : BaseHospital)
}

class SelectUnitVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let hospitalData = HospitalHandler()
     let unitData = UnitHandler()
    var units : [BaseUnit] = []
    var hospitals : [BaseHospital] = []
    public var delegate : unitSelectedProtocol?
    public var type : availableTypes = .unitselector
    enum availableTypes {
        case unitselector
        case hospitalselector
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //do something
        if(type == .hospitalselector)
        {
            return hospitals.count
        }
        else
        {
            return units.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "selectUnitCell") as! UnitSelectCostumTableViewCell
        if(type == .unitselector)
        {
            let unit = units[indexPath.row]
            cell.Callsign.text = unit.funkrufName
            
            cell.crewCount.text = ""
            
            cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
            cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
        }
        else
        {
            let hospital = hospitals[indexPath.row]
            cell.Callsign.text = hospital.name
            cell.type.text = hospital.city
            cell.crewCount.text = ""
            cell.pictureBox.image = UIImage(named: "hospital.png")
        }
        //do something
     
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(type == .unitselector)
        {
            self.delegate!.didSelectUnit(unit: units[indexPath.row])
        }
        else
        {
            self.delegate!.didSelectHospital(hospital: hospitals[indexPath.row])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func abort_click(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        units = unitData.getAllBaseUnits()
        hospitals = hospitalData.getAllHospitals()
        table.delegate = self
        table.dataSource = self
        

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
