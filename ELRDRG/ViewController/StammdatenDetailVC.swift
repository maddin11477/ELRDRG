//
//  StammdatenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class StammdatenDetailVC: UIViewController , UnitProtocol, HospitalProtocol, InjuryProtocol, UITableViewDataSource, UITableViewDelegate{
    func createdInjury() {
        injuries = injuryData.getAllBaseInjury()
        print(injuries.count)
        table.reloadData()
    }
    
    
    enum StammdatenTyp{
        case Fahrzeuge
        case Kliniken
        case Diagnosen
    }
    
    let unitData = UnitHandler()
    let injuryData = InjuryHandler()
    let hospitalData = HospitalHandler()
   
    public var type : StammdatenTyp = StammdatenTyp.Diagnosen
   
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    var units : [BaseUnit] = []
    var hospitals : [BaseHospital] = []
    var injuries : [BaseInjury] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(type == .Fahrzeuge)
        {
            return units.count
        }
        else if(type == .Kliniken)
        {
            return hospitals.count
        }
        else
        {
            print(injuries.count)
            return injuries.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if(type == .Fahrzeuge)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCostumTableViewCell") as! UnitCostumTableViewCell
            cell.CallSign.text = units[row].funkrufName
            cell.CrewCount.text = String(units[row].crewCount)
            cell.UnitType.text = unitData.BaseUnit_To_UnitTypeString(id: units[row].type)
            
            
            cell.PictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: units[row].type))
            return cell
            
        }
        else if(type == .Kliniken)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCostumTableViewCell") as! HosiptalCostumTableViewCell
            cell.Name.text = hospitals[row].name
            cell.City.text = hospitals[row].city
            return cell
        }
        else
        {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "InjuryCostumTableViewCell") as! InjuryCostumTableViewCell
                cell.Name.text = injuries[row].diagnosis
                cell.Location.text = injuries[row].loaction
                return cell
            
            
            
        }
       
    }
    
    
    
    func createdHospital() {
        //dosomething
       
        hospitals = hospitalData.getAllHospitals()
        
        table.reloadData()
    }
    
    func createdUnit() {
        //dosomething
        print("created")
      
        units = unitData.getAllBaseUnits()
        table.reloadData()
    }
    
    func createdUser(user: User) {
        print(String(user.callsign!))
    }
    
    func createdDiagnose(diagnose: BaseInjury) {
        
       
    }
    
    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if(type == .Diagnosen)
        {
            injuryData.delegate = self
            injuries = injuryData.getAllBaseInjury()
            navBarItem.title = "Diagnosen"
        }
        else if(type == .Fahrzeuge)
        {
            unitData.delegate = self
            units = unitData.getAllBaseUnits()
            navBarItem.title = "Fahrzeuge"
        }
        else if(type == .Kliniken)
        {
            hospitalData.delegate = self
            hospitals = hospitalData.getAllHospitals()
            navBarItem.title = "Kliniken"
        }
        
        
        
        table.dataSource = self
        table.delegate = self
        table.reloadData()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func add_click(_ sender: Any)
    {
        if(type == .Fahrzeuge)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateUnitVC") as! CreateUnitVC
           // vc.hospitalData = hospitalData
           // vc.injuryData = injuryData
            vc.unitdata = unitData
           
            self.present(vc, animated: true, completion: nil)
        }
        else if(type == .Kliniken)
        {
            handleHospitalAddAction()
        }
        else if(type == .Diagnosen)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateInjuryVC") as! CreateInjuryVC
            vc.injuryData = injuryData
            self.present(vc, animated: true, completion: nil)
           
        }
     
       
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            if(type == .Fahrzeuge)
            {
              
                let alert : UIAlertController = UIAlertController(title: "Löschen", message: ("Sind Sie sicher, dass Sie  " + units[indexPath.row].funkrufName! + " Löschen möchten?"), preferredStyle: UIAlertControllerStyle.alert)
                let alertaction : UIAlertAction = UIAlertAction(title: "Löschen", style: .destructive, handler: { alert -> Void in
                    self.unitData.deleteBaseUnit(baseUnit: self.units[indexPath.row])
                    self.units = self.unitData.getAllBaseUnits()
                    self.table.reloadData()
                   
                    
                })
                let abortaction : UIAlertAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
                alert.addAction(alertaction)
                alert.addAction(abortaction)
                self.present(alert, animated: true, completion: nil)
            }
            else if(type == .Kliniken)
            {
                let alert : UIAlertController = UIAlertController(title: "Löschen", message: ("Sind Sie sicher, dass Sie  " + hospitals[indexPath.row].name! + " Löschen möchten?"), preferredStyle: UIAlertControllerStyle.alert)
                let alertaction : UIAlertAction = UIAlertAction(title: "Löschen", style: .destructive, handler: { alert -> Void in
                    self.hospitalData.deleteBaseHospital(basehospital: self.hospitals[indexPath.row])
                    self.hospitals = self.hospitalData.getAllHospitals()
                    self.table.reloadData()
                    
                    
                })
                let abortaction : UIAlertAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
                alert.addAction(alertaction)
                alert.addAction(abortaction)
                self.present(alert, animated: true, completion: nil)
            }
            else if(type == .Kliniken)
            {
                let alert : UIAlertController = UIAlertController(title: "Löschen", message: ("Sind Sie sicher, dass Sie  " + injuries[indexPath.row].diagnosis! + " Löschen möchten?"), preferredStyle: UIAlertControllerStyle.alert)
                let alertaction : UIAlertAction = UIAlertAction(title: "Löschen", style: .destructive, handler: { alert -> Void in
                    self.injuryData.deleteBaseInjury(baseInjury:  self.injuries[indexPath.row])
                    self.injuries = self.injuryData.getAllBaseInjury()
                    self.table.reloadData()
                    
                    
                })
                let abortaction : UIAlertAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
                alert.addAction(alertaction)
                alert.addAction(abortaction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
           
            
            
        }
    }
    
    
    func handleHospitalAddAction()
    {
        let alertController = UIAlertController(title: "Klinik", message: "Stammdaten Krankenhaus erstellen", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Krankenhaus"
        }
        alertController.addTextField {(textField : UITextField!) -> Void in
            textField.placeholder = "Stadt"
        }
        let saveAction = UIAlertAction(title: "Erstellen", style: .default, handler: { alert -> Void in
            let hospitalName = (alertController.textFields![0] as UITextField).text
            let hospitalCity = (alertController.textFields![1] as UITextField).text
            if((alertController.textFields![0] as UITextField).text != "" && (alertController.textFields![1] as UITextField).text != "")
            {
                self.hospitalData.addBaseHospital(name: hospitalName!, city: hospitalCity!)
                self.hospitalData.delegate?.createdHospital()
            }
           
            
        })
        
        let abortaction = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(abortaction)
        self.present(alertController, animated: true, completion: nil)
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
