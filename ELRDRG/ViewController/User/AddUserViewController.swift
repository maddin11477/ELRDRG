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
class AddUserViewController: UIViewController {

    public var delegate : AddUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lbl_lastName: UITextField!
    
    
    @IBOutlet weak var lbl_firstName: UITextField!
    
    @IBOutlet weak var lblPassword: UITextField!

    @IBAction func addUser(_ sender: Any)
    {
        let dataHandler = DataHandler()
       
        var AlertView : UIAlertController
        
        //Resultcode: 0=already exists, 1=success, -1=wrong parameters
        let resultCode = dataHandler.createUser(password: lblPassword.text ?? "", firstname: lbl_firstName.text ?? "", lastname: lbl_lastName.text ?? "", isAdmin: false)
        if(resultCode == 0)
        {
            AlertView = UIAlertController(title: "ERFOLG", message: "Der Benutzer wurde erfolgreich angelegt", preferredStyle: .actionSheet)
             let action = UIAlertAction(title: "OK", style: .default, handler: createdUserCompletion)
            AlertView.addAction(action)
              self.present(AlertView, animated: true, completion: nil)
             self.delegate?.addedUser()
           
            
           
            
        }
        if(resultCode == 1)
        {
            
             let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            AlertView = UIAlertController(title: "ACHTUNG", message: "Alle Felder müssen ausgefüllt werden!", preferredStyle: .alert)
            AlertView.addAction(action)
            self.present(AlertView, animated: true, completion: nil)

        }
        
        if(resultCode == -1)
        {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            AlertView = UIAlertController(title: "ACHTUNG", message: "Benutzer bereits vorhanden", preferredStyle: .alert)
            AlertView.addAction(action)
            self.present(AlertView, animated: true, completion: nil)
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
