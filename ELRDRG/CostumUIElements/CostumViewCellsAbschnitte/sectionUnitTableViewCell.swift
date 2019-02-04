//
//  sectionUnitTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class sectionUnitTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if(unit_?.patient != nil)
        {
            number = 2
            if(unit_!.patient?.hospital != nil)
            {
                number = 3
            }
        }
        tableHeight.constant = CGFloat(number * 49)
        return number
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            let unitData = UnitHandler()
            let cell = table.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
            cell.funkRufName.text = unit_!.callsign
            cell.crewCount.text = String(describing: unit_!.crewCount)
            cell.unitType.text = unitData.BaseUnit_To_UnitTypeString(id: unit_!.type)
            cell.unitTypeImage.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit_!.type))
            return cell
        }
        else if(indexPath.row == 1)
        {
            let cell = table.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
            let victim = unit_?.patient
            cell.firstName.text = victim?.firstName
            cell.lastName.text = victim?.lastName
            cell.PatID.text = "Pat-ID: " + String(victim!.id)
            cell.category.text = String(victim!.category)
            cell.patient = victim
            return cell
        }
        else
        {
            let cell = table.dequeueReusableCell(withIdentifier: "SmallhospitalTableViewCell") as! SmallhospitalTableViewCell
            cell.City.text = unit_!.patient!.hospital?.city
            cell.Name.text = unit_!.patient!.hospital?.name
            return cell
        }
       
    }
    
    
    public func setProperties()
    {
        table.dataSource = self
        table.delegate = self
       
        
        
        table.reloadData()
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    public var delegate : UnitSectionDelegate? = nil
    
    public var unit_ : Unit?

    
    
 
    
   
    
    
 
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
