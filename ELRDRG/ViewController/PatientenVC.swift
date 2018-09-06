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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "PatientenDetailView") as! PatientenDetailVC
        detailController.victim = victimList[indexPath.row]
        self.present(detailController, animated: true, completion: nil)
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sort()
        return victimList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //neue zelle generieren
        let cell = patientTable.dequeueReusableCell(withIdentifier: "PatientCustomTableViewCell") as! PatientCustomTableViewCell
        
        //labels befüllen
        cell.ID.text = String(victimList[indexPath.row].id)
        cell.category.text = String(victimList[indexPath.row].category)
        cell.birthDate.text = String(victimList[indexPath.row].age)
        cell.firstName.text = victimList[indexPath.row].firstName
        cell.lastName.text = victimList[indexPath.row].lastName
        cell.hospital.text = victimList[indexPath.row].hospital?.name
        cell.unit.text = victimList[indexPath.row].fahrzeug?.callsign
        
        //Farbe einstellen
        if(victimList[indexPath.row].category == 1)
        {
            cell.category.backgroundColor = .red
        }
        else if(victimList[indexPath.row].category == 2)
        {
            cell.category.backgroundColor = .orange
        }
        else if(victimList[indexPath.row].category == 3)
        {
            cell.category.backgroundColor = .green
        }
        else if(victimList[indexPath.row].category == 4)
        {
            cell.category.backgroundColor = UIColor.white
            cell.category.text = ""
        }
        else if(victimList[indexPath.row].category == 5)
        {
            cell.category.backgroundColor = UIColor.black
            cell.category.text = ""
        }
        if(victimList[indexPath.row].age == -1)
        {
            cell.birthDate.text = ""
        }
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            
             
             let alert : UIAlertController = UIAlertController(title: "Löschen", message: "Sind Sie sicher, dass Sie Pat. " + (String(indexPath.row + 1)) + " Löschen möchten?", preferredStyle: UIAlertControllerStyle.alert)
            let alertaction : UIAlertAction = UIAlertAction(title: "Löschen", style: .destructive, handler: { alert -> Void in
                
                self.data.deleteVictim(victim: self.victimList[indexPath.row])
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
