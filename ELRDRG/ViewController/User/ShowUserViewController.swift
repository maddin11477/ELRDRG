//
//  ShowUserViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.11.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class ShowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Name") as! UserAttributeTableViewCell
        if(indexPath.row == 0)
        {
            cell.Description.text = "Telefon"
            cell.Content.text = user!.phone ?? ""
            cell.propertyType = .PhoneNumber
            
        }
        if(indexPath.row == 1)
        {
            cell.Description.text = "E-Mail"
            cell.Content.text = user!.eMail ?? ""
            cell.propertyType = .eMail
        }
        
        if(indexPath.row == 2)
              {
                  cell.Description.text = "Benutzertyp"
                if(user!.isAdmin)
                {
                    cell.Content.text = "Administrator"
                }
                else
                {
                     cell.Content.text = "ELRD"
                }
                cell.Content.tintColor = .black
                  
                cell.propertyType = .UserType
              }
       
        
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    public var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(user != nil)
        {
            lbl_area.text = "Bereitschaft Rhön-Grabfeld"
            lbl_username.text = user!.firstName! + " " + user!.lastName!
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
    }
    
    
    @IBAction func deleteUser(_ sender: Any)
    {
        let button = sender as? UIButton
       
        let alert = UIAlertController(title: "Huubsi", message: "Funktion noch nicht implementiert", preferredStyle: .actionSheet)
             let action = UIAlertAction(title: "OK Cool", style: .cancel, handler: nil)
    }
    @IBAction func editUser(_ sender: Any)
    {
        let alert = UIAlertController(title: "Huubsi", message: "Funktion noch nicht implementiert", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK Cool", style: .cancel, handler: nil)
    }
    
    @IBOutlet weak var lbl_area: UILabel!
    
    @IBOutlet weak var lbl_username: UILabel!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
