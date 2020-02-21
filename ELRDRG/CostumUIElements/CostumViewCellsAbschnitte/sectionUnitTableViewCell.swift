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
			if let pat = self.patient_
			{
				if let unit = item.dragItem.localObject as? Unit
				{
					unit.section?.removeFromUnits(unit)

					unit.section = nil
					unit.section = pat.section
					unit.section?.addToUnits(unit)
					unit.addToPatient(pat)
					pat.addToFahrzeug(unit)
					patient_!.section!.removeFromVictims(patient_!)
					pat.section = nil
					DataHandler().saveData()
					if let delegate = self.delegate
					{
						delegate.droppedVictim()
					}



				}
				table.reloadData()
				return
			}
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
						patient.section?.removeFromVictims(patient)
						patient.section = nil
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
		if let _ = session.items[0].localObject as? Unit
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
		if let _ = self.unit_
		{
			//unit
			if(unit_?.patient != nil)
			{
				number = (unit_?.getVictimCount() ?? 0) + 1
				height = 30 * number
			}

			tableHeight.constant = CGFloat(height )
			return number
		}
		else
		{
			number = 1
			tableHeight.constant = CGFloat(26)
			return number
		}

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var row = indexPath.row
		if let _ = self.patient_
		{
			row = 1
		}
        if(row == 0)
        {
            let unitData = UnitHandler()
            let cell = table.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
            cell.funkRufName.text = unit_!.callsign
            
           
            cell.unitTypeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit_!.type))
            return cell
        }
        else if(row > 0)
        {
            let cell = table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
            //let victim = (unit_?.patient?.allObjects as? [Victim])[indexPath.row - 1]
			var pat : Victim?
            if let victimList = (unit_?.patient?.allObjects as? [Victim])
            {
				 pat = victimList[indexPath.row - 1]
			}
			else
			{
				pat = self.patient_
			}
			if let victim = pat
			{

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
					cell.category.text = ""
					cell.category.backgroundColor = UIColor.lightGray
                }
				else if victim.category == 5
				{
					cell.category.text = ""
					//cell.category.textColor = UIColor.white
					cell.category.backgroundColor = UIColor.black
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
	public var patient_ : Victim?
    public var unitChangedDelegate : changedUnitDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
