//
//  sectionUnitTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol VictimDropDelegate {
    func droppedVictim()
}

class sectionUnitTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, UITableViewDropDelegate, changedUnitDelegate {
    
    func reloadTable() {
        table.reloadData()
        self.unitChangedDelegate?.reloadTable()
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        for item in coordinator.items
        {
            
            if let patient = item.dragItem.localObject as? Victim
            {
               
                if((patient.fahrzeug?.allObjects as! [Unit]).count > 0)
                {
                    let messageString = "Der Patient wurde bereits dem " + ((patient.fahrzeug?.allObjects as! [Unit])[0].callsign ?? "unbekannt") + " zugeordnet."
                    let alert = UIAlertController(title: "Achtung", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else
                {
                    
                        unit_?.addToPatient(patient)
                        let secData = SectionHandler()
                        secData.saveData()
                        self.delegate?.droppedVictim()
                        table.reloadData()
                    
                    
                    
                }
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        if let _ = session.items[0].localObject as? Victim
        {
            return true
        }
        else
        {
            return false
        }
       
    }
    
    
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var height = 37
        var number : Int = 1
        
        if(unit_?.patient != nil)
        {
            number = (unit_?.getVictimCount() ?? 0) + 1
            height = 30 * number
        }
        
        tableHeight.constant = CGFloat(height )
        return number
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            let unitData = UnitHandler()
            let cell = table.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
            cell.funkRufName.text = unit_!.callsign
            
           
            cell.unitTypeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit_!.type))
            return cell
        }
        else if(indexPath.row > 0)
        {
            let cell = table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
            //let victim = (unit_?.patient?.allObjects as? [Victim])[indexPath.row - 1]
            if let victimList = (unit_?.patient?.allObjects as? [Victim])
            {
                let victim = victimList[indexPath.row - 1]
                cell.firstName.text = "  " + (victim.firstName ?? "") + " " + (victim.lastName ?? "")
                
                cell.PatID.text = "Pat: " + String(victim.id)
				if victim.category > -1
				{
					cell.category.text = String(victim.category)
				}
				else
				{
					cell.category.text = ""
				}

				cell.hospitalInfoStateColorElement.backgroundColor = victim.getHospitalInfoState()
                if(victim.category == 1)
                {
                    cell.category.backgroundColor = UIColor.red
                }
                else if(victim.category == 2)
                {
                    cell.category.backgroundColor = UIColor.orange
                }
                else if(victim.category == 3)
                {
                    cell.category.backgroundColor = UIColor.green
                }
                else if(victim.category == 4)
                {
                    cell.category.backgroundColor = UIColor.blue
                }
                else
                {
					cell.category.backgroundColor = UIColor(named: "UIBackcolor_NEW")
                }
                
                cell.patient = victim
                cell.fahrzeug = unit_
                cell.delegate = self
                
                if(victim.hospital != nil)
                {
                    cell.removeHospitalBtn.isHidden = false
                    cell.destination.text = "  " + (victim.hospital!.name ?? "")
                }
                else
                {
                    cell.destination.text = ""
                    cell.removeHospitalBtn.isHidden = true
                }
                
                return cell
            }
            
        }
        
        //Überflüssig aber für die Sicherheit geb ich halt noch was zurück
        let cell = table.dequeueReusableCell(withIdentifier: "SmallhospitalTableViewCell") as! SmallhospitalTableViewCell
        //cell.City.text = unit_!.patient!.hospital?.city
        //cell.Name.text = unit_!.patient!.hospital?.name
        return cell
        
       
    }
    
    
    public func setProperties()
    {
        table.dataSource = self
        table.delegate = self
       
        table.dropDelegate = self
        
        table.reloadData()
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    public var delegate : VictimDropDelegate?
    
    public var unit_ : Unit?
    public var unitChangedDelegate : changedUnitDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
