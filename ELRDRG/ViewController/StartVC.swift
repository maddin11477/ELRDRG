//
//  ViewController.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class StartVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var Login: LoginHandler = LoginHandler()
    
    @IBOutlet weak var searchMissions: UISearchBar!
    @IBOutlet weak var allowedMissions: UITableView!
    @IBOutlet weak var newMission: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showLoginPopover"{
            if(loginButton.title == "Anmelden"){
                return true
            }
            else{
                Login.loggOffUser()
                adaptUIForLoggedInUser(userLoggedIn: false)
                return false
            }
        }
        else
        {
            return true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func adaptUIForLoggedInUser(userLoggedIn: Bool){
        if(userLoggedIn){
            loginButton.title = "Abmelden"
            searchMissions.isHidden = false
            allowedMissions.isHidden = false
            newMission.isHidden = false
        }
        else{
            loginButton.title = "Anmelden"
            searchMissions.isHidden = true
            allowedMissions.isHidden = true
            newMission.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Check of die Anwendung das erste mal gestartet wird, wenn ja dann Onboarding
        if(Login.isAppAlreadyLaunchedOnce()){
            //start application with normal UI and proceed
            print("Normal app start... yeah!")
            //Schauen ob bereits jemand angemledet ist. Wenn nicht auf Anmeldung warten
            if let user = Login.getLoggedInUser(){
                adaptUIForLoggedInUser(userLoggedIn: true)
                loadAllAllowedMissions(loggedInUser: user)
            }
            else {
                adaptUIForLoggedInUser(userLoggedIn: false)
                
            }
        }
        else
        {
            //App startet zum ersten mal
            doOnboarding()
            adaptUIForLoggedInUser(userLoggedIn: false)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doOnboarding(){
        //TODO: Onboarding: Hier kann Erklärung kommen und so weiter... aktuell wird nur das Passwort für den Admin Zugang abgefragt
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
    }
    
    func loadAllAllowedMissions(loggedInUser user: User){
        //TODO: Alle Einsätze laden, die dieser Nutzer sehen darf
        print("")
    }

}

