//
//  AbschnitteVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class AbschnitteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDragDelegate, SectionDropProtocol, UICollectionViewDropDelegate, OrganisationAddedTempObjectProtocoll, AbschnitteSectionTVCDelegate{
	func dropFailed(controller: UIAlertController) {
		self.present(controller, animated: true, completion: nil)
	}
    
    func addSection(section: BaseSection) {
        SectionHandler().addSection(identifier: section.identifier ?? "")
        dropedUnitInSection()
        self.AbschnitteCollectionView.reloadData()
    }

    
    
    func createdUnit() {
        //
        self.SourceTable.reloadData()
		self.AbschnitteCollectionView.reloadData()
    }
    
    func createdSection() {
        print("createdSection")
        self.SourceTable.reloadData()
		self.AbschnitteCollectionView.reloadData()

    }
    
    func droppedPatientInUnit() {
        self.SourceTable.reloadData()
    }
    
    var editViewsVisible : Bool = false
    @IBAction func Show_Hide_EditViews(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        if(editViewsVisible)
        {
            btn.setTitle("", for: .normal)
            EditViewsWidthConstraints.constant = 0
        }
        else
        {
            btn.setTitle("", for: .normal)
            EditViewsWidthConstraints.constant = 418
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        editViewsVisible = !editViewsVisible
        
    }
    
    @IBOutlet weak var EditViewsWidthConstraints: NSLayoutConstraint!
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("section.identifier")
        for item in coordinator.items
        {
            
            if let sectionCell = item.dragItem.localObject as? AbschnitteSectionTVC
            {
                
                
                let secData = SectionHandler()
                secData.addSection(identifier: sectionCell.Name.text ?? "unbekannt")
                
                dropedUnitInSection()
                AbschnitteCollectionView.reloadData()
            }
          
            
        }
        SourceTable.reloadData()
        print("reload")

    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
       if let _ = session.items[0].localObject as? AbschnitteSectionTVC
       {
            return true
        }
       else
       {
        return false
        }
        //return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        
        print("test")
        if let _ = session.items[0].localObject as? AbschnitteSectionTVC
        {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
         }
        else
        {
         return  UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
         }
        
        
        
        
       
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
        baseUnits =  baseUnits.sorted(by: { $0.funkrufName!.lowercased() < $1.funkrufName!.lowercased() })
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
                if let abschnitt = (SourceTable.cellForRow(at: indexpath) as? AbschnitteSectionTVC)
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
		self.sections = sectionData.getSections()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            if(section == 1)
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
    
    @IBAction func AddObject(_ sender: Any) {
        let addView = self.storyboard?.instantiateViewController(withIdentifier: "CreateTempObjectViewController") as! CreateTempObjectViewController
		addView.delegate = self
        addView.modalPresentationStyle = .popover
        addView.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        self.present(addView, animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            if(section == 0)
            {
                return units.count
            }
            else
            {
                return baseUnits.count
                
            }
            
           
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            print("segment1")
            let data = DataHandler()
            let victimlist = data.getVictims()
            var i : Int = 0//victimlist.count
            print(i)
            victims = []
            for victim in victimlist {
                
				if(victim.fahrzeug?.allObjects.count == 0 && victim.section == nil)
                {
                    
                    victims.append(victim)
                    i = i + 1
                    print(i)
                }
            }
            return i
        }
        else
        {
            let data = SectionHandler()
            baseSections = data.getAllSections()
            return data.getAllSections().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(SegmentControl.selectedSegmentIndex == 0)
        {
            //Fahrzeuge
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallUnitTableViewCell") as! SmallUnitTableViewCell
            if(indexPath.section == 1)
            {
                
                    cell.funkRufName.text = baseUnits[indexPath.row].funkrufName
                    cell.crewCount.text = String(baseUnits[indexPath.row].crewCount)
                    let handler = UnitHandler()
                    cell.unit = handler.baseUnit_To_Unit(baseUnit: baseUnits[indexPath.row])
                    cell.unitType.text = handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type)
                    cell.unitTypeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type))
                    cell.backgroundColor = UIColor.white
                    return cell
                
                
            }
            else
            {
                cell.funkRufName.text = units[indexPath.row].callsign
                cell.crewCount.text = String(units[indexPath.row].crewCount)
                let handler = UnitHandler()
                cell.unit = units[indexPath.row]
                cell.backgroundColor = UIColor(hue: 0.2917, saturation: 0.35, brightness: 0.92, alpha: 1.0)
                    
                cell.unitType.text = handler.BaseUnit_To_UnitTypeString(id: units[indexPath.row].type)
                cell.unitTypeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: units[indexPath.row].type))
                return cell
            }
            
        }
        else if(SegmentControl.selectedSegmentIndex == 1)
        {
            //Patienten
            let cell = tableView.dequeueReusableCell(withIdentifier: "SmallPatientTableViewCell") as! SmallPatientTableViewCell
           /* var victimlist : [Victim] = []
            for pat in victims {
                if(pat.fahrzeug == nil)
                {
                    victimlist.append(pat)
                }
            }*/
            let victim = victims[indexPath.row]
            cell.firstName.text = victim.firstName
            cell.lastName.text = victim.lastName
            cell.PatID.text = "Pat-ID: " + String(victim.id)
            cell.category.text = String(victim.category)
            cell.patient = victim
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
                cell.category.backgroundColor = UIColor.white
            }
            return cell
        }
        else
        {
            //Einsatzabschnitte
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! AbschnitteSectionTVC
            let section = baseSections[indexPath.row]
            cell.Name.text = section.identifier
            cell.section = section
            cell.delegate = self
            
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
        filterSegmentControl.tintColor = UIColor.black
        // Do any additional setup after loading the view.
        
        AbschnitteCollectionView.contentInset = UIEdgeInsetsMake(20, 10, 10, 10)
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
