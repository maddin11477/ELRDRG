//
//  AbschnitteVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class AbschnitteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData.getSections().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = AbschnitteCollectionView.dequeueReusableCell(withReuseIdentifier: "AbschnittCVC", for: indexPath) as! AbschnittCVC
        view.Abschnittname.title = sectionData.getSections()[indexPath.row].identifier ?? "unbekannt"
        view.section_ = sectionData.getSections()[indexPath.row]
        view.table.delegate = view
        view.table.dataSource = view
        return view
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            return "Fahrzeuge ohne Patient"
        }
        else
        {
            return "Fahrzeuge mit Patient"
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
                cell.unitType.text = handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type)
                cell.unitTypeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: baseUnits[indexPath.row].type))
                return cell
            }
            else
            {
                cell.funkRufName.text = units[indexPath.row].callsign
                cell.crewCount.text = String(units[indexPath.row].crewCount)
                let handler = UnitHandler()
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
    
  
   
    
    
    @IBOutlet weak var AbschnitteCollectionView: UICollectionView!
    
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var SourceTable: UITableView!
    let sectionData : SectionHandler = SectionHandler()
    
    @IBAction func SegmentValueChanged(_ sender: Any)
    {
        SourceTable.reloadData()
    }
    
  
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    var victims : [Victim] = []
    var units : [Unit] = []
    var baseUnits : [BaseUnit] = []
    var baseSections : [BaseSection] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
       
        let abschnitt = baseSections[indexPath.row]
        
        let itemProvider = NSItemProvider(object: abschnitt.identifier! as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = abschnitt
        
        
        return [dragItem]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let data = DataHandler()
        let unitData = UnitHandler()
        let sectionData = SectionHandler()
        //sectionData.addSection(identifier: "Schaden")
        AbschnitteCollectionView.delegate = self
        AbschnitteCollectionView.dataSource = self
        baseUnits = unitData.getAllBaseUnits()
        baseSections = sectionData.getAllSections()
        victims = data.getVictims()
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
        // sectionData.getSections()[0].addToUnits(unitData.baseUnit_To_Unit(baseUnit: baseUnits[0]))
        SourceTable.dataSource = self
        SourceTable.delegate = self
        SourceTable.reloadData()
        // SourceTable.dragDelegate = self
        // SourceTable.dropDelegate = self
        AbschnitteCollectionView.reloadData()
        AbschnitteCollectionView.dragInteractionEnabled = true
        
        SourceTable.dragInteractionEnabled = true
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
