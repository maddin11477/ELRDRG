//
//  AbschnittCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
protocol SectionDropProtocol {
    func dropedUnitInSection()
}
class AbschnittCVC: UICollectionViewCell,UITableViewDataSource, UITableViewDelegate, UITableViewDropDelegate, UITableViewDragDelegate {
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexpath : IndexPath) -> [UIDragItem]
    {
        
        let string = NSAttributedString(string: (section_?.units?.allObjects as! [Unit])[indexpath.row].callsign!)
        
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
               let car = (section_?.units?.allObjects as! [Unit])[indexpath.row]
                
                    dragItem.localObject = car
                
                return [dragItem]
            
        
        
        
        return []
    }
    
    
    
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    
    
    var anzahlRTW = 0
    var anzahlKTW = 0
    var anzahlRTH = 0
    var anzahlNEF = 0
    var anzahlSonstige = 0
    
    
    @IBAction func deleteSection_Click(_ sender: Any)
    {
        let lecdata = SectionHandler()
        for car in section_?.units?.allObjects as! [Unit] {
            car.section = nil
        }
        lecdata.deleteSection(sec: section_!)
        self.dropDelegate.dropedUnitInSection()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //let destinationPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items
        {
           
                if let unit = item.dragItem.localObject as? Unit
                {
                    
                    section_?.addToUnits(unit)
                    unit.section = section_
                    let secData = SectionHandler()
                    secData.saveData()
                    self.dropDelegate.dropedUnitInSection()
                    table.reloadData()
                }
            
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let anzahl =  (section_?.units?.allObjects.count) ?? 0
         anzahlRTW = 0
         anzahlKTW = 0
         anzahlRTH = 0
         anzahlNEF = 0
         anzahlSonstige = 0
    
        self.layer.shadowColor = UIColor.black.cgColor
       
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        return anzahl
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let unit = section_?.units?.allObjects[(indexPath.row)] as! Unit
        unit.section = nil
        section_!.removeFromUnits(unit)
        
        let handler = SectionHandler()
        handler.saveData()
        table.reloadData()
        self.dropDelegate.dropedUnitInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unitData = UnitHandler()
        /*
        case RTW = 0
        case KTW = 1
        case NEF = 2
        case RTH = 3
        case HVO = 4
         */
        let unit = (section_!.units!.allObjects as! [Unit])[indexPath.row]
        if(unit.type == 0)
        {
            //RTW
            anzahlRTW = 1 + anzahlRTW
        }
        else if(unit.type == 1)
        {
            //KTW
            anzahlKTW = 1 + anzahlKTW
        }
        else if(unit.type == 2)
        {
            anzahlNEF = 1 + anzahlNEF
        }
        else if(unit.type == 3)
        {
            anzahlRTH = 1 + anzahlRTH
        }
        else if(unit.type == 4)
        {
            anzahlSonstige = 1 + anzahlSonstige
        }
        lblKTW.text = "KTW: " + String(anzahlKTW)
        lblRTH.text = "RTH: " + String(anzahlRTH)
        lblRTW.text = "RTW: " + String(anzahlRTW)
        lblNEF.text = "NEF: " + String(anzahlNEF)
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
   public var dropDelegate : SectionDropProtocol!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var Abschnittname: UINavigationItem!
    @IBOutlet weak var lblKTW: UILabel!
    @IBOutlet weak var lblRTW: UILabel!
    @IBOutlet weak var lblNEF: UILabel!
    @IBOutlet weak var lblRTH: UILabel!
    
}
