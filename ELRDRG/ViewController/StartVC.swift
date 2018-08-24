//
//  ViewController.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class StartVC: UIViewController {
    
    var users: [User] = []
    var Login: LoginHandler = LoginHandler()
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    @IBAction func loginButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(Login.isAppAlreadyLaunchedOnce()){
            //start application with normal UI and proceed
            print("Normal app start... yeah!")
            //Lese alle User aus Datenbank
            users = LoginHandler.getAllUsers()
            print(users.count)
            
            
            
            //Debug
            
            for x in users {
                print(x.lastName ?? "leer")
            }
            
        }
        else
        {
            //this is the first start, show UI to enter the Admin password and add a Admin user
            let alertController = UIAlertController(title: "Bitte Passwort für den Administrator Zugang festlegen.", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Admin-Passwort"
            }
            let saveAction = UIAlertAction(title: "Speichern", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                self.Login.addAdminUser(password: firstTextField.text!)
            })
            
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            getAllAllowedMissions()
        }
        
    }
    
    private func getAllAllowedMissions(){
        let user: User = Login.getLoggedInUser()!
            if(user != nil){
                //Daten in Tableview laden, sonst nichts machen
                loginButton.title = "Abmelden"
            }
            else{
                loginButton.title = "Anmelden"
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

