//
//  PatientPopOverVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 12.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit


class PatientPopOverVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public func close() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return injuries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! injuryTVC
        cell.content = injuries[indexPath.row].displayText
        return cell
    }
    
	@IBOutlet var lbl_SK_big: UILabel!

    @IBOutlet var lbl_sk: UILabel!
    
    @IBOutlet var lbl_pat_id: UILabel!
    
    @IBOutlet var lbl_name: UILabel!
    
    @IBOutlet var lbl_birthdate_age: UILabel!
    
    @IBOutlet var lbl_unit: UILabel!
    
    @IBOutlet var lbl_destination: UILabel!
    
    @IBOutlet var lbl_transportation_time: UILabel!
    
    
    @IBOutlet var tableView: UITableView!
    
    var injuries : [Injury] = []
    
    public var patient : Victim?
    
    
    @IBAction func close_click(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_sk.text = ""
        lbl_name.text = ""
        lbl_pat_id.text = ""
        lbl_name.text = ""
        lbl_birthdate_age.text = ""
        lbl_unit.text = ""
        lbl_destination.text = ""
        lbl_transportation_time.text = ""
        injuries.removeAll()
        if let pat = self.patient
        {
           self.lbl_sk.text = String(pat.category)
           self.lbl_name.text = (pat.firstName ?? "") + " " + (pat.lastName ?? "")
           self.lbl_pat_id.text = String(pat.id)
			self.lbl_SK_big.text = String(pat.id)
          
           //Transport Time
           if let date = pat.isDone
           {
               let dateformatter = DateFormatter()
               dateformatter.dateFormat = "dd.MM.yyyy - hh:mm"
               self.lbl_transportation_time.text = dateformatter.string(from: date) + " Uhr"
               
           }
           
           
           //BIRTHDAY
           if let birthdate = pat.birthdate
           {
               let dateformatter = DateFormatter()
               dateformatter.dateFormat = "dd.MM.yyyy"
               self.lbl_birthdate_age.text = dateformatter.string(from: birthdate)
                if(pat.age > 0)
                {
                    self.lbl_birthdate_age.text! += " / "
                }
           }
            
           //AGE
           if(pat.age > 0)
           {
              self.lbl_birthdate_age.text =  (self.lbl_birthdate_age.text ?? "") +  String(pat.age)
           }
           
           //UNITS
           var s_unit : String = ""
           if let units = pat.fahrzeug?.allObjects as? [Unit]
           {
               for unit in units {
                   
                   s_unit += (unit.callsign ?? "")
                   if(unit != units[units.count - 1])
                   {
                      s_unit += "\n"
                   }
               }
               self.lbl_unit.text = s_unit
           }
           
           //DESTINATION
           if let destination = pat.hospital
           {
               lbl_destination.text = (destination.name ?? "") + " " + (destination.city ?? "")
               
           }
           
           
           self.injuries = (pat.verletzung?.allObjects as? [Injury]) ?? []
           
           
           
       }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    

    

}
