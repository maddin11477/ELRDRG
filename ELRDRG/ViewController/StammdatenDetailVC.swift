//
//  StammdatenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class StammdatenDetailVC: UIViewController , StammdatenProtocol, UITableViewDataSource, UITableViewDelegate{
    
    let baseData = BaseDataHandler()
    
   
    
    
    @IBOutlet weak var table: UITableView!
    
    
    
    var units : [BaseUnit] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseData.getAllBaseUnits().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCostumTableViewCell") as! UnitCostumTableViewCell
        cell.CallSign.text = units[row].funkrufName
        cell.CrewCount.text = String(units[row].crewCount)
        cell.UnitType.text = baseData.BaseUnit_To_UnitTypeString(id: units[row].type)
        
        
        cell.PictureBox.image = UIImage(named: baseData.BaseUnit_To_UnitTypeString(id: units[row].type))
        return cell
    }
    
    
    
    func createdHospital(hospital: BaseHospital) {
        //dosomething
        print(String(hospital.name!))
    }
    
    func createdUnit() {
        //dosomething
        print("created")
        let basedata = BaseDataHandler()
        units = basedata.getAllBaseUnits()
        table.reloadData()
    }
    
    func createdUser(user: User) {
        print(String(user.callsign!))
    }
    
    func createdDiagnose(diagnose: BaseInjury) {
        print(String(diagnose.diagnosis!))
    }
    
    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    
    let data : DataHandler = DataHandler()
    public var type : DataHandler.StammdatenTyp = DataHandler.StammdatenTyp.Diagnosen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        units = baseData.getAllBaseUnits()
        baseData.delegate = self 
        table.dataSource = self
        table.delegate = self
        table.reloadData()
        if(type == .Diagnosen)
        {
            navBarItem.title = "Diagnosen"
        }
        else if(type == .Fahrzeuge)
        {
            navBarItem.title = "Fahrzeuge"
        }
        else if(type == .Kliniken)
        {
            navBarItem.title = "Kliniken"
        }
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func add_click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateUnitVC") as! CreateUnitVC
        vc.basedata = baseData
        //vc.modalPresentationStyle = .popover
        
        
        self.present(vc, animated: true, completion: nil)
       
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
