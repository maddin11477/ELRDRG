//
//  ViewController.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class StartVC: UIViewController, LoginProtocol, missionProtocol, UITableViewDelegate, UITableViewDataSource, changedMissionDelegate {
	func didEndEditingMission() {
		missions = data.getAllMissions(missions: true)
		allowedMissions.reloadData()
	}

    //Dies ist eine Teständerung
    var missions : [Mission] = []
	var othersMissions : [Mission] = []
    var Login: LoginHandler = LoginHandler()
    let data: DataHandler = DataHandler()
    
    @IBOutlet weak var searchMissions: UISearchBar!
    @IBOutlet weak var allowedMissions: UITableView!
    @IBOutlet weak var newMission: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var lblCurrentUser: UIBarButtonItem!
    

	@IBOutlet var cmdSettings: UIBarButtonItem!


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
            else
            {
                self.data.addMission(reason: "Neuer Einsatz")
            }
            
        })
        
        let abortaction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(abortaction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }

	func numberOfSections(in tableView: UITableView) -> Int {
		if SettingsHandler().getSettings().showAllMissions
		{
			return 2
		}
		else
		{
			return 1
		}
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0
		{
			missions = DataHandler().getAllMissions(missions: true)
			missions.sort {
				$1.start! < $0.start!
			}
			return missions.count
		}
		else
		{
			othersMissions = DataHandler().getAllMissions(missions: false)
			othersMissions.sort {
				$1.start! < $0.start!
			}
			return othersMissions.count
		}



    }

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0
		{
			return "Eigene Einsätze"
		}
		else
		{
			return "Einsätze anderer Benutzer"
		}
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0
		{
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
		}
		else
		{
			if(indexPath.row < othersMissions.count)
			{
				Login.setCurrentMissionUnique(unique: othersMissions[indexPath.row].unique!)
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
		}


			//


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var missionList : [Mission] = []
		if indexPath.section == 0
		{
			missionList = self.missions
		}
		else
		{
			missionList = self.othersMissions
		}
        let cell = allowedMissions.dequeueReusableCell(withIdentifier: "MissionCostumTableViewCell") as! MissionCostumTableViewCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.Date.text = formatter.string(from: missionList[indexPath.row].start!)
		let id =  missionList.count - indexPath.row
        cell.ID.text = String(id)
        cell.Reason.text = missionList[indexPath.row].reason
		if missionList[indexPath.row].isFinished
		{
			cell.missionStateImage.image = UIImage(systemName: "checkmark.circle.fill")
			cell.missionStateImage.tintColor = UIColor.green
		}
		else
		{
			cell.missionStateImage.image = UIImage(systemName: "xmark.circle.fill")
			cell.missionStateImage.tintColor = UIColor.lightGray
		}
		cell.delegate = self
		cell.mission = missionList[indexPath.row]
		cell.storyboard = self.storyboard
		cell.viewController = self
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
				cmdSettings.isEnabled = false
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
		missions = data.getAllMissions(missions: true)
        allowedMissions.delegate = self
        allowedMissions.dataSource = self
        allowedMissions.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        

    }
    
    
    func loginUser(user: User) {
        Login.loggInUser(user: user)
        adaptUIForLoggedInUser(userLoggedIn: true)
		self.missions = DataHandler().getAllMissions(missions: true)
		self.allowedMissions.reloadData()
		self.cmdSettings.isEnabled = true
    }
    
    func adaptUIForLoggedInUser(userLoggedIn: Bool){
        if(userLoggedIn){
            loginButton.title = "Abmelden"
            lblCurrentUser.title = Login.getLoggedInUserName()
            searchMissions.isHidden = true
            allowedMissions.isHidden = false
            newMission.isHidden = false
			cmdSettings.isEnabled = true
        }
        else{
            loginButton.title = "Anmelden"
            lblCurrentUser.title = Login.getLoggedInUserName()
            searchMissions.isHidden = true
            allowedMissions.isHidden = true
            newMission.isHidden = true
			cmdSettings.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
		self.missions = DataHandler().getAllMissions(missions: true)
		self.allowedMissions.reloadData()
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

