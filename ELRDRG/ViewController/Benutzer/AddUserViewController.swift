//
//  AddUserViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 16.11.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
protocol AddUserDelegate {
     func addedUser()
}
class AddUserViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddUserAttributeTableViewCell") as! AddUserAttributeTableViewCell
        


		if let currentuser = self.user
		{
			switch indexPath.row {
			case 0:

				cell.Headline.text = "Vorname"
				cell.TextField.text = currentuser.firstName
			case 1:
				cell.Headline.text = "Nachname"
				cell.TextField.text = currentuser.lastName
			case 2:
				cell.Headline.text = "Passwort"
				cell.TextField.isSecureTextEntry = true
				cell.TextField.text = currentuser.password
			case 3:
				cell.Headline.text = "E-Mail"
				cell.TextField.text = currentuser.eMail
			case 4:
				cell.Headline.text = "Telefonnummer"
				cell.TextField.text = currentuser.phone
			case 5:
				cell.Headline.text = "Funkrufname"
				cell.TextField.text = currentuser.callsign
			default:
				cell.Headline.text = "Unbekannt"
			}
		}
		else
		{
			switch indexPath.row {
			case 0:

				cell.Headline.text = "Vorname"
			case 1:
				cell.Headline.text = "Nachname"
			case 2:
				cell.Headline.text = "Passwort"
				cell.TextField.isSecureTextEntry = true
			case 3:
				cell.Headline.text = "E-Mail"
			case 4:
				cell.Headline.text = "Telefonnummer"
			case 5:
				cell.Headline.text = "Funkrufname"
			default:
				cell.Headline.text = "Unbekannt"
				}
		}
        
        return cell
    }
    

    public var delegate : AddUserDelegate?
	public var user : User?

	@IBOutlet var cmd_create_safe: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
		if let _ = self.user
		{
			cmd_create_safe.setTitle("Speichern", for: .normal)
		}
		else
		{
			cmd_create_safe.setTitle("Benutzer anlegen", for: .normal)
		}
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    



    @IBAction func exitViewController(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addUser(_ sender: Any)
    {
       
        let firstname = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddUserAttributeTableViewCell).TextField.text
        let lastName = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddUserAttributeTableViewCell).TextField.text
        let password = (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! AddUserAttributeTableViewCell).TextField.text
        let eMail = (tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! AddUserAttributeTableViewCell).TextField.text
        let phone = (tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! AddUserAttributeTableViewCell).TextField.text
		let callsign = (tableView.cellForRow(at: IndexPath(row: 5, section : 0)) as! AddUserAttributeTableViewCell).TextField.text
        let dataHandler = DataHandler()
       
        var AlertView : UIAlertController
        
        //Resultcode: 0=already exists, 1=success, -1=wrong parameters
		if let currentUser = self.user
		{
			currentUser.firstName = firstname
			currentUser.lastName = lastName
			currentUser.password = password
			currentUser.eMail = eMail
			currentUser.phone = phone
			currentUser.callsign = callsign
			dataHandler.saveData()
			self.delegate?.addedUser()
			self.dismiss(animated: true, completion: nil)
		}
		else
		{
			let resultCode = dataHandler.createUser(password: password ?? "", firstname: firstname ?? "", lastname: lastName ?? "", isAdmin: false, eMail: eMail ?? "", phone: phone ?? "", callsign: callsign ?? "")
			if(resultCode == 1)
			{
				AlertView = UIAlertController(title: "ERFOLG", message: "Der Benutzer wurde erfolgreich angelegt", preferredStyle: .actionSheet)
				let action = UIAlertAction(title: "OK", style: .default, handler: createdUserCompletion)
				AlertView.addAction(action)
				AlertView.modalPresentationStyle = .formSheet
				AlertView.popoverPresentationController?.sourceView = self.view
				self.present(AlertView, animated: true, completion: nil)
				self.delegate?.addedUser()




			}
			if(resultCode == 0)
			{

				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				AlertView = UIAlertController(title: "ACHTUNG", message: "Alle Felder müssen ausgefüllt werden!", preferredStyle: .alert)
				AlertView.addAction(action)
				AlertView.modalPresentationStyle = .formSheet
				AlertView.popoverPresentationController?.sourceView = self.view
				self.present(AlertView, animated: true, completion: nil)

			}

			if(resultCode == -1)
			{
				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				AlertView = UIAlertController(title: "ACHTUNG", message: "Benutzer bereits vorhanden", preferredStyle: .alert)
				AlertView.addAction(action)
				AlertView.modalPresentationStyle = .formSheet
				AlertView.popoverPresentationController?.sourceView = self.view
				self.present(AlertView, animated: true, completion: nil)
			}
		}

        

        
    }
    
    func createdUserCompletion(alert :UIAlertAction)
    {
         self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
