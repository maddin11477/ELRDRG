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
}

class SelectUnitVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
     let unitData = UnitHandler()
    var units : [BaseUnit] = []
    public var delegate : unitSelectedProtocol?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //do something
       
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //do something
        let cell = table.dequeueReusableCell(withIdentifier: "selectUnitCell") as! UnitSelectCostumTableViewCell
        let unit = units[indexPath.row]
        cell.Callsign.text = unit.funkrufName
        
        cell.crewCount.text = ""
       
        cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
        cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate!.didSelectUnit(unit: units[indexPath.row])
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
