//
//  ShowUserViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 23.11.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class ShowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var delegete : AddUserDelegate?
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
      /*  let button = sender as? UIButton
       
        let alert = UIAlertController(title: "Huubsi", message: "Funktion noch nicht implementiert", preferredStyle: .actionSheet)
             let action = UIAlertAction(title: "OK Cool", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)*/
        let loginHandler = LoginHandler()
        
        let ownUser : User = loginHandler.getLoggedInUser()!
        //Überpüfe ob eigener Benutzer ausgewählt wurde
        if(ownUser.unique! == user!.unique!)
        {
            let alertController = UIAlertController(title: "NEIN!", message: "Sie können nicht Ihren eigenen Benutzer löschen!", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertController.addAction(action)
            alertController.popoverPresentationController?.sourceView = self.view
           self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        //Warnen bevor Benutzer gelöscht wird
        let userMessage : String = "Sind Sie sicher, dass Sie den Benutzer " + user!.firstName! + " " + user!.lastName! + " löschen möchten?"
        let Alert = UIAlertController(title: "Löschen?", message: userMessage, preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Löschen", style: .destructive, handler: self.removeUser)
        Alert.addAction(actionDelete)
        let actionAbort = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        Alert.addAction(actionAbort)
        Alert.modalPresentationStyle = .popover
        Alert.popoverPresentationController?.sourceView = self.view
        self.present(Alert, animated: true, completion: nil)
    }
    
    
    @IBAction func editUser(_ sender: Any)
    {
        let alert = UIAlertController(title: "Huubsi", message: "Funktion noch nicht implementiert", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK Cool", style: .cancel, handler: nil)
        alert.addAction(action)
        //self.present(alert, animated: true, completion: nil)
    }
    
    func removeUser(action : UIAlertAction)
    {
        let loginHandler = LoginHandler()
        loginHandler.deleteUser(user: user!)
        self.delegete?.addedUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lbl_area: UILabel!
    
    @IBOutlet weak var lbl_username: UILabel!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
