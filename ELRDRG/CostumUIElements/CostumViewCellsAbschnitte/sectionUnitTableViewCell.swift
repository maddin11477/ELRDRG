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

public enum CellType{
	case Victim
	case Unit
	case UnitPattern
}

class sectionUnitTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, UITableViewDropDelegate, changedUnitDelegate {
    
    func reloadTable() {
        table.reloadData()
        self.unitChangedDelegate?.reloadTable()
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        for item in coordinator.items
        {
			if self.type == CellType.UnitPattern
			{
				if let unit = item.dragItem.localObject as? Unit
				{

					if (unit.getVictims()?.count ?? 0) == 0
					{
						unit.section?.removeFromUnits(unit)
						unit.section = nil
						unit.section = self.pattern!.units[0].section
						unit.addToPatient(self.pattern!.victim)
						self.pattern!.victim.addToFahrzeug(unit)
						if let delegate = self.delegate
						{
							delegate.droppedVictim()
						}
						table.reloadData()
					}
					else
					{
						var parentResponder : UIResponder? = self
						while parentResponder != nil{
							parentResponder = parentResponder!.next
							if let viewController = parentResponder as? UIViewController{
								let controller = UIAlertController(title: "Nicht möglich!", message: "Leider ist es diesem Verbund von Einsatzkräften nicht möglich, ein Patienten besetztes Fahrzeug hinzuzufügen.", preferredStyle: .alert)
								let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
								controller.addAction(action)
								viewController.present(controller, animated: true, completion: nil)
							}
						}
					}

				}
			}

			if self.type == CellType.Unit && (self.unit_!.getVictims()!.count ) == 1
			{
				if let unit = item.dragItem.localObject as? Unit
				{
					if(unit.getVictims()?.count ?? 0) == 0
					{
						unit.section?.removeFromUnits(unit)
						unit.section = nil
						unit.section = self.unit_!.section
						unit.addToPatient(self.unit_!.getVictims()![0])
						unit.getVictims()![0].addToFahrzeug(unit)
						if let delegate = self.delegate
						{
							delegate.droppedVictim()
						}
						table.reloadData()

					}
					else
					{
						var parentResponder : UIResponder? = self
						while parentResponder != nil{
							parentResponder = parentResponder!.next
							if let viewController = parentResponder as? UIViewController{
								let controller = UIAlertController(title: "Nicht möglich!", message: "Leider ist es diesem Verbund von Einsatzkräften nicht möglich, ein Patienten besetztes Fahrzeug hinzuzufügen.", preferredStyle: .alert)
								let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
								controller.addAction(action)
								viewController.present(controller, animated: true, completion: nil)
							}
						}
					}
				}
			}

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
					pat.section!.removeFromVictims(pat)
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
						patient.handledUnit = nil
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
		if let _ = session.items[0].localObject as? UnitPattern
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
		if self.type! == CellType.Unit
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
		else if self.type! == CellType.UnitPattern
		{
			let number = (self.pattern!.units.count + 1)
			height = 32 * (number)
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

		switch self.type!
		{
			case CellType.Victim:
				return generateVictimCell(indexPath: indexPath)
			case CellType.Unit:
				return generateUnitCell(indexPath: indexPath)
			case CellType.UnitPattern:
				return generateUnitPatterCell(indexPath: indexPath)
		}
       
    }

	private func generateUnitCell(indexPath : IndexPath)->UITableViewCell
	{
		if indexPath.row == 0
		{
			let cell = self.table.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
			//TODO: generate Unit Cell
			let relatedUnit = unit_!
			cell.funkRufName.text = relatedUnit.callsign
			cell.unitTypeImage.image = UIImage(named: UnitHandler().BaseUnit_To_UnitTypeString(id: relatedUnit.type))
			return cell
		}
		else
		{
			let cell = self.table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
			let victim = self.unit_!.getVictims()![indexPath.row - 1]
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

	private func generateVictimCell(indexPath : IndexPath)->UITableViewCell
	{

		// -------- UNIT --------
		if indexPath.row == 0
		{
			if let _ = unit_
			{
				return generateUnitCell(indexPath: indexPath)
			}
			else
			{
				return generateVictimCell(indexPath: IndexPath(row: indexPath.row + 1, section: indexPath.section))
			}
			//return UITableViewCell(style: .default, reuseIdentifier: "SmallPatientTableViewCell")
		}
			// ------ VICTIMS -------
		else
		{
			let cell = self.table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
			let victim = self.patient_!
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

	private func generateUnitPatterCell(indexPath : IndexPath)->UITableViewCell
	{
		if indexPath.row < self.pattern!.units.count
		{
			let cell = self.table.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
			//TODO: generate Unit Cell from unit List in UnitPattern
			let unit = self.pattern!.units[indexPath.row]
			cell.funkRufName.text = unit.callsign

			cell.unitTypeImage.image = UIImage(named: UnitHandler().BaseUnit_To_UnitTypeString(id: unit.type))
			return cell
		}
		else
		{
			let cell = self.table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
			//TODO: generate Patient Cell with patient / victim from pattern
			if let pat = self.pattern
			{

				let victim = pat.units[0].getVictims()![indexPath.row - self.pattern!.units.count]
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
			return cell
		}
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
	public var pattern : UnitPattern?
    public var unit_ : Unit?
	public var patient_ : Victim?
    public var unitChangedDelegate : changedUnitDelegate?
	public var type : CellType?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
