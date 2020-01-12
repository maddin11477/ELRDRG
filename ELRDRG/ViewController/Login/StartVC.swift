//
//  ViewController.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class StartVC: UIViewController, LoginProtocol, missionProtocol, UITableViewDelegate, UITableViewDataSource {
    //Dies ist eine Teständerung
    var missions : [Mission] = []
    var Login: LoginHandler = LoginHandler()
    let data: DataHandler = DataHandler()
    
    @IBOutlet weak var searchMissions: UISearchBar!
    @IBOutlet weak var allowedMissions: UITableView!
    @IBOutlet weak var newMission: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var lblCurrentUser: UIBarButtonItem!
    
    
    @IBAction func newMission_Click(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Einsatzname", message: "Stichwort für Schadensereignis", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Einsatzname"
        }
        let createAction = UIAlertAction(title: "Anlegen", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let text = firstTextField.text
            if((text?.count)! > 0 && text != " ")
            {
                self.data.addMission(reason: text!)
            }
            
        })
        
        let abortaction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(abortaction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(indexPath.row < missions.count)
		{
			Login.setCurrentMissionUnique(unique: missions[indexPath.row].unique!)
			if let nc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC
			{
				nc.modalPresentationStyle = .fullScreen
				self.present(nc, animated: true, completion: nil)
			}

		}
		else
		{
			let alertController = UIAlertController(title: "Index aus of Range! ", message: "Index: " +  String(indexPath.row), preferredStyle: .alert)
			let alertaction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
			alertController.addAction(alertaction)
			self.present(alertController, animated: false, completion: nil)

		}


			//


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allowedMissions.dequeueReusableCell(withIdentifier: "MissionCostumTableViewCell") as! MissionCostumTableViewCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.Date.text = formatter.string(from: missions[indexPath.row].start!)
        cell.ID.text = String(indexPath.row + 1)
        cell.Reason.text = missions[indexPath.row].reason
        return cell
    }
    
    
    func updatedMissionList(missionList: [Mission]) {
        missions = missionList
        allowedMissions.reloadData()
    }
    
    
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showLoginPopover"){
            let popoverViewController = segue.destination as! LoginPopupVC
            // added Line
            popoverViewController.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.delegate = self
        missions = data.getAllMissions()
        allowedMissions.delegate = self
        allowedMissions.dataSource = self
        allowedMissions.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        

    }
    
    
    func loginUser(user: User) {
        Login.loggInUser(user: user)
        adaptUIForLoggedInUser(userLoggedIn: true)
    }
    
    func adaptUIForLoggedInUser(userLoggedIn: Bool){
        if(userLoggedIn){
            loginButton.title = "Abmelden"
            lblCurrentUser.title = Login.getLoggedInUserName()
            searchMissions.isHidden = false
            allowedMissions.isHidden = false
            newMission.isHidden = false
        }
        else{
            loginButton.title = "Anmelden"
            lblCurrentUser.title = Login.getLoggedInUserName()
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
                if(user.currentMissionUnique != nil)
                {
                    
                    if(data.getMissionFromUnique(unique: user.currentMissionUnique!) != nil)
                    {
                        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
                
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

