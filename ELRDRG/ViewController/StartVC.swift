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
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var userCount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Lese alle User aus Datenbank
        users = DataHandler.getAllUsers()
        print(users.count)
        
        
        
        if users.count == 0 //wenn noch keiner in Datenbank, dann neuen Anlegen -> MasterUser oder UI für initial start
        {
            print("No users found, adding a default user")
            DataHandler.addUser(lastname: "Administrator", firstname: "Admin")
            users = DataHandler.getAllUsers()
            print(users)
        }
        
        //Debug
        
        for x in users {
            print(x.lastName ?? "leer")
        }
        
        
        //Testing
        userText.text = users[0].lastName! + ", " + users[0].firstName!
        userCount.text = String(users.count)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        let newNr = users.count + 1
        DataHandler.addUser(lastname: "Administrator" + String(newNr), firstname: "Admin" + String(newNr))
        users = DataHandler.getAllUsers()
    }
    
    @IBAction func TestPushed(_ sender: UIButton) {
        print("You pushed the test button")
        
    }
    
    
    
   
    
    
}

