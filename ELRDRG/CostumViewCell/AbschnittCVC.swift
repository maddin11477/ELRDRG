//
//  AbschnittCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class AbschnittCVC: UICollectionViewCell,UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let anzahl =  (section_?.units?.allObjects.count) ?? 0
        print("Anzahl EInheiten in Abschnitt")
        print(anzahl)
        return anzahl
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unitData = UnitHandler()
        
        let unit = (section_!.units!.allObjects as! [Unit])[indexPath.row]
        if let patient = unit.patient
        {
            if let destination = patient.hospital
            {
                let cell = table.dequeueReusableCell(withIdentifier: "sectionUnitFullTableViewCell") as! sectionUnitFullTableViewCell
                cell.callSign.text = unit.callsign
                cell.crewCount.text = String(unit.crewCount)
                cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
                cell.typeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
                cell.id.text = String(patient.id)
                cell.lastname.text = patient.lastName
                cell.firstName.text = patient.firstName
                cell.category.text = String(patient.category)
                cell.destinationCity.text = destination.city
                cell.destinationName.text = destination.name
                return cell
                
                
            }
            let cell = table.dequeueReusableCell(withIdentifier: "sectionUnitHalfTableViewCell") as! sectionUnitHalfTableViewCell
            cell.callSign.text = unit.callsign
            cell.crewCount.text = String(unit.crewCount)
            cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
            cell.typeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
            cell.id.text = String(patient.id)
            cell.lastName.text = patient.lastName
            cell.firstName.text = patient.firstName
            cell.category.text = String(patient.category)
            
            return cell
        }
        else
        {
            let cell = table.dequeueReusableCell(withIdentifier: "sectionUnitTableViewCell") as! sectionUnitTableViewCell
            cell.callSign.text = unit.callsign
            cell.crewCount.text = String(unit.crewCount)
            cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
            cell.typeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
          
            
            return cell
        }
        
    }
    
    
    
    public var section_ : Section?
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var Abschnittname: UINavigationItem!
    @IBOutlet weak var lblKTW: UILabel!
    @IBOutlet weak var lblRTW: UILabel!
    @IBOutlet weak var lblNEF: UILabel!
    @IBOutlet weak var lblRTH: UILabel!
    
}
