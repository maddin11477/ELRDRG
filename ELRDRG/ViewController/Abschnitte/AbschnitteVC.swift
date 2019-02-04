//
//  AbschnitteVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class AbschnitteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDragDelegate, SectionDropProtocol, UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("section.identifier")
        for item in coordinator.items
        {
            
            if let sectionCell = item.dragItem.localObject as? SectionTableViewCell
            {
                
                
                let secData = SectionHandler()
                secData.addSection(identifier: sectionCell.Name.text ?? "unbekannt")
                
                dropedUnitInSection()
                AbschnitteCollectionView.reloadData()
            }
          
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
       
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func dropedUnitInSection() {
        
        units = []
        sections = []
        baseUnits = []
        baseSections = []
        //Filter der jeweiligen Tabellen
        //Laden der Daten
        let data = DataHandler()
        let unitData = UnitHandler()
        let sectionData = SectionHandler()
        baseUnits = unitData.getAllBaseUnits()
        baseSections = sectionData.getAllSections()
        victims = data.getVictims()
        sections = sectionData.getSections()
        
        
        for patient in victims {
            if let cars : [Unit] = patient.fahrzeug?.allObjects as? [Unit]
            {
                for car in cars
                {
                    
                    
                    if(car.section == nil)
                    {
                        units.append(car)
                        
                        
                    }
                    
                    
                }
                
            }
        }
        
        
        
        for sec in sections {
            
            for car in sec.units?.allObjects as! [Unit]
            {
                for u in baseUnits
                {
                    
                    if(u.funkrufName == car.callsign)
                    {
                        
                        if let index = baseUnits.index(of: u)
                        {
                            baseUnits.remove(at: index)
                        }
                    }
                }
            }
        }
        filterByType()
        print("reload after delegate")
        SourceTable.reloadData()
        AbschnitteCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexpath : IndexPath) -> [UIDragItem]
    {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            
            if let  string = (SourceTable.cellForRow(at: indexpath) as? SmallUnitTableViewCell)?.funkRufName.attributedText
            {
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
                if let car = (SourceTable.cellForRow(at: indexpath) as? SmallUnitTableViewCell)?.unit
                {
                    dragItem.localObject = car
                }
                return [dragItem]
            }
            
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            let string = NSURL(fileURLWithPath: "PatientItem")
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
            if let patient = (SourceTable.cellForRow(at: indexpath) as? SmallPatientTableViewCell)?.patient!
            {
                dragItem.localObject = patient
            }
            return [dragItem]
            
            
        }
        else if(SegmentControl.selectedSegmentIndex == 2)
        {
                let string = NSURL(fileURLWithPath: "testfileNotImportantWhatIsWrittenHere")
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
                if let abschnitt = (SourceTable.cellForRow(at: indexpath) as? SectionTableViewCell)
                {
                    dragItem.localObject = abschnitt
                    
                }
                return [dragItem]
            
        }
        
        return []
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = AbschnitteCollectionView.dequeueReusableCell(withReuseIdentifier: "AbschnittCVC", for: indexPath) as! AbschnittCVC
        view.Abschnittname.title = sections[indexPath.row].identifier ?? "unbekannt"
        view.section_ = sections[indexPath.row]
        view.table.dropDelegate = view
        view.dropDelegate = self
        view.table.dragDelegate = view
        
        view.table.delegate = view
        view.table.dataSource = view
        view.table.reloadData()
        print("reloaded")
        return view
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            if(section == 0)
            {
                return "Stammdaten"
            }
            else
            {
                return "Einsatzmittel bereits im Einsatz"
            }
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            return "Patienten"
        }
        else
        {
            return "Einsatzabschnitte"
        }
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            return 2
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            if(section == 0)
            {
                return baseUnits.count
            }
            else
            {
                return units.count
            }
            
           
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            let data = DataHandler()
            return data.getVictims().count
        }
        else
        {
            let data = SectionHandler()
            return data.getAllSections().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            //Fahrzeuge
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
            if(indexPath.section == 0)
            {
                
                    cell.funkRufName.text = baseUnits[indexPath.row].funkrufName
                    cell.crewCount.text = String(baseUnits[indexPath.row].crewCount)
                    let handler = UnitHandler()
                    cell.unit = handler.baseUnit_To_Unit(baseUnit: baseUnits[indexPath.row])
                    cell.unitType.text = handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type)
                    cell.unitTypeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type))
                    return cell
                
                
            }
            else
            {
                cell.funkRufName.text = units[indexPath.row].callsign
                cell.crewCount.text = String(units[indexPath.row].crewCount)
                let handler = UnitHandler()
                cell.unit = units[indexPath.row]
                cell.unitType.text = handler.BaseUnit_To_UnitTypeString(id: units[indexPath.row].type)
                cell.unitTypeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: units[indexPath.row].type))
                return cell
            }
            
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            //Patienten
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
            let victim = victims[indexPath.row]
            cell.firstName.text = victim.firstName
            cell.lastName.text = victim.lastName
            cell.PatID.text = "Pat-ID: " + String(victim.id)
            cell.category.text = String(victim.category)
            cell.patient = victim
            return cell
        }
        else
        {
            //Einsatzabschnitte
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! SectionTableViewCell
            let section = baseSections[indexPath.row]
            cell.Name.text = section.identifier
            cell.zusatz.text = ""
            return cell
        }
    }
    
    func filterByType()
    {
        
        var tempUnitList : [Unit] = []
        var tempBaseUnitList : [BaseUnit] = []
        
        for unit in units {
            if(filterSegmentControl.selectedSegmentIndex == unit.type || filterSegmentControl.selectedSegmentIndex == 5 || (filterSegmentControl.selectedSegmentIndex == 4 && unit.type > 3))
            {
                tempUnitList.append(unit)
                
            }
        }
        
        for unit in baseUnits
        {
            if(filterSegmentControl.selectedSegmentIndex == unit.type || filterSegmentControl.selectedSegmentIndex == 5 || (filterSegmentControl.selectedSegmentIndex == 4 && unit.type > 3))
            {
                tempBaseUnitList.append(unit)
                
            }
        }
        baseUnits = tempBaseUnitList
        units = tempUnitList
    }
    
  
   
    
    
    @IBOutlet weak var AbschnitteCollectionView: UICollectionView!
    
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var SourceTable: UITableView!
    let sectionData : SectionHandler = SectionHandler()
    @IBOutlet weak var filterSegmentControlHeight: NSLayoutConstraint!
    
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    
    @IBAction func filterSegmentControl_ValueChanged(_ sender: Any) {
        dropedUnitInSection()
    }
    
    @IBAction func SegmentValueChanged(_ sender: Any)
    {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            filterSegmentControlHeight.constant = 28
            filterSegmentControl.tintColor = UIColor.red
        }
        else
        {
            filterSegmentControl.tintColor = UIColor.white
            filterSegmentControlHeight.constant = 0
        }
        SourceTable.reloadData()
    }
    
  
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    var victims : [Victim] = []
    var units : [Unit] = []
    var baseUnits : [BaseUnit] = []
    var baseSections : [BaseSection] = []
    var sections : [Section] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AbschnitteCollectionView.delegate = self
        AbschnitteCollectionView.dataSource = self
        SourceTable.dataSource = self
        SourceTable.delegate = self
        filterSegmentControl.selectedSegmentIndex = 5
        filterSegmentControl.tintColor = UIColor.red
        // Do any additional setup after loading the view.
    }
    
    
    
  
    

    
    override func viewDidAppear(_ animated: Bool) {
     
        
        
        
        
        
        dropedUnitInSection()
        AbschnitteCollectionView.dropDelegate = self
        
        SourceTable.reloadData()
    
        SourceTable.dragDelegate = self
        
        
        AbschnitteCollectionView.reloadData()
        AbschnitteCollectionView.dragInteractionEnabled = true
        
        SourceTable.dragInteractionEnabled = true
        
        
    }

   

  

}
