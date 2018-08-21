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
        getAllUsersFromDB()
        
        if users.count == 0 //wenn noch keiner in Datenbank, dann neuen Anlegen -> MasterUser oder UI für initial start
        {
            print("No users found, adding a default user")
            addUserToDataBase(lastname: "Administrator", firstname: "Admin")
            print(users)
        }
        
        //Debug
        print(users)
        
        
        //Testing
        userText.text = users[0].lastName! + ", " + users[0].firstName!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        let newNr = users.count + 1
        addUserToDataBase(lastname: "Administrator" + String(newNr), firstname: "Admin" + String(newNr))
        getAllUsersFromDB()
    }
    
    @IBAction func TestPushed(_ sender: UIButton) {
        print("You pushed the test button")
        
    }
    
    private func getAllUsersFromDB(){
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        do
        {
            users = try AppDelegate.viewContext.fetch(userRequest)
            userCount.text = String(users.count)
        }
        catch
        {
            print(error)
        }
    }
    
    private func addUserToDataBase(lastname last: String, firstname first:String){
        print("Adding Firstname: " + first + " Lastname: " + last)
        let user = User(context: AppDelegate.viewContext)
        user.firstName = first
        user.lastName = last
        print("Added to DB")
        
        do
        {
            try AppDelegate.viewContext.save()
        }
        catch
        {
            print(error)
        }
    }
}

