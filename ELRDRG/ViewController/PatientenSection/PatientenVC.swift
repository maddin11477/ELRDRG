//
//  PatientenVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class PatientenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let data : DataHandler = DataHandler()
    let login : LoginHandler = LoginHandler()
    var sortById : Bool = true
    var victimList : [Victim] = []
    
    @IBOutlet weak var patientTable: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var SortSegment: UISegmentedControl!
    
  
    @IBAction func AddKat3_click(_ sender: Any)
    {
        data.ceateVictim(age: -1, category: 3, firstName: nil, lastName: nil, id: Int16(victimList.count + 1))
        
        victimList = data.getVictims()
        patientTable.reloadData()
    }
    
    func sort()
    {
        if(sortById == true)
        {
         victimList.sort(by: { $0.id < $1.id})
        }
        else
        {
            victimList.sort(by: {$0.category < $1.category})
        }
    }
    
    
    
    @IBAction func SortSegmend_ValChanged(_ sender: Any)
    {
        if(SortSegment.selectedSegmentIndex == 0)
        {
            
            //sortButton.title? = "Sortiere nach Nummer"
            sortById = false
            sort()
        }
        else
        {
            
            sortById = true
            //sortButton.title? = "Sortiere nach Kategorie"
            sort()
        }
        patientTable.reloadData()
    }
    
    
    @IBAction func SortByCategory_Button_Click(_ sender: Any)
    {
       
       
    }
    
   
    @IBAction func AddKatUngesichtet_click(_ sender: Any)
    {
        data.ceateVictim(age: -1, category: -1, firstName: nil, lastName: nil, id: Int16(victimList.count + 1))
        victimList = data.getVictims()
        patientTable.reloadData()
    }
    
    @IBAction func AddKat2_click(_ sender: Any)
    {
        data.ceateVictim(age: -1, category: 2, firstName: nil, lastName: nil, id: Int16(victimList.count + 1))
        victimList = data.getVictims()
        patientTable.reloadData()
    }
    @IBAction func AddKat1_click(_ sender: Any)
    {
        data.ceateVictim(age: -1, category: 1, firstName: nil, lastName: nil, id: Int16(victimList.count + 1))
        victimList = data.getVictims()
        patientTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var openList : [Victim] = []
        var doneList : [Victim] = []
        for vic in victimList {
            if(vic.isDone == nil)
            {
                openList.append(vic)
            }
            else
            {
                doneList.append(vic)
            }
        }
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "PatientenDetailView") as! PatientenDetailVC
        if(indexPath.section == 0)
        {
            detailController.victim = openList[indexPath.row]
        }
        else
        {
            detailController.victim = doneList[indexPath.row]
        }
        self.navigationController?.pushViewController(detailController, animated: true)
        //self.navigationController?.present(detailController, animated: true, completion: nil)
        //self.present(detailController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            return "Patienten an der Einsatzstelle"
        }
        else
        {
            return "Transportierte Patienten"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sort()
       
       
    
        var countDone : Int = 0
        var countNotDone : Int = 0
        for vic in victimList {
            if(vic.isDone == nil)
            {
                countNotDone = countNotDone + 1
            }
            else
            {
                countDone = countDone + 1
            }
        }
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            if(countNotDone > 0)
            {
                tabItem.badgeValue = String(countNotDone)
                tabItem.badgeColor = UIColor.red
            }
            else
            {
                tabItem.badgeValue = "Erledigt"
                tabItem.badgeColor = UIColor.green
            }
        }
        if(section == 0)
        {
            return countNotDone
        }
        else
        {
            return countDone
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Seperieren der VictimListe
        var openList : [Victim] = []
        var doneList : [Victim] = []
        for vic in victimList {
            if(vic.isDone == nil)
            {
                openList.append(vic)
            }
            else
            {
                doneList.append(vic)
            }
        }
        
        //neue zelle generieren
        let cell = patientTable.dequeueReusableCell(withIdentifier: "PatientCustomTableViewCell") as! PatientCustomTableViewCell
        var pat : Victim
        if(indexPath.section == 0)
        {
            pat = openList[indexPath.row]
        }
        else
        {
            pat = doneList[indexPath.row]
        }
        //labels befüllen
        cell.ID.text = String(pat.id)
        cell.category.text = String(pat.category)
        cell.birthDate.text = String(pat.age) + " j."
        cell.firstName.text = pat.firstName
        cell.lastName.text = pat.lastName
        cell.hospital.text = pat.hospital?.name
        cell.child.isHidden = true
        cell.helicopter.isHidden = true
        cell.sht.isHidden = true
        cell.heatinjury.isHidden = true
        if(pat.child == true)
        {
            cell.child.isHidden = false
        }
        if(pat.helicopter == true)
        {
            cell.helicopter.isHidden = false
        }
        if(pat.sht == true)
        {
            cell.sht.isHidden = false
        }
        if(pat.heatInjury == true)
        {
            cell.heatinjury.isHidden = false
        }
        if(pat.category == -1)
        {
            cell.category.isHidden = true
        }
        else
        {
            cell.category.isHidden = false
        }
       
        var text = ""
        for car in pat.fahrzeug?.allObjects as! [Unit]
        {
            text = text + car.callsign! + ", "
        }
        
        cell.unit.text = text
        
        //Farbe einstellen
        if(pat.category == 1)
        {
            cell.category.backgroundColor = .red
        }
        else if(pat.category == 2)
        {
            cell.category.backgroundColor = .orange
        }
        else if(pat.category == 3)
        {
            cell.category.backgroundColor = .green
        }
        else if(pat.category == 4)
        {
            cell.category.backgroundColor = UIColor.white
            cell.category.text = ""
        }
        else if(pat.category == 5)
        {
            cell.category.backgroundColor = UIColor.black
            cell.category.text = ""
        }
        if(pat.age == -1)
        {
            cell.birthDate.text = ""
        }
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            //Seperieren der VictimListe
            var openList : [Victim] = []
            var doneList : [Victim] = []
            for vic in self.victimList {
                if(vic.isDone == nil)
                {
                    openList.append(vic)
                }
                else
                {
                    doneList.append(vic)
                }
            }
            var pat : Victim
            if(indexPath.section == 0)
            {
                pat = openList[indexPath.row]
                
            }
            else
            {
                pat = doneList[indexPath.row]
            }
             
             let alert : UIAlertController = UIAlertController(title: "Löschen", message: "Sind Sie sicher, dass Sie Pat. " + (String(pat.id)) + " Löschen möchten?", preferredStyle: UIAlertControllerStyle.alert)
            let alertaction : UIAlertAction = UIAlertAction(title: "Löschen", style: .destructive, handler: { alert -> Void in
               
                self.data.deleteVictim(victim: pat)
                self.victimList = self.data.getVictims()
                self.patientTable.reloadData()
                
                })
            let abortaction : UIAlertAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
            alert.addAction(alertaction)
            alert.addAction(abortaction)
            self.present(alert, animated: true, completion: nil)
             
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientTable.delegate = self
        patientTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
       victimList = data.getVictims()
        patientTable.reloadData()
        
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
