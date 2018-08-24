//
//  LoginHandler.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public struct LoginHandler {
    
    public func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    public func addAdminUser(password: String){
        addUser(lastname: "Administrator", firstname: "Admin", password: password, isAdmin: true)
        print ("Added Adminuser...let's continue")
    }
    
    public func logginUser(unique : String){
        let defaults = UserDefaults.standard
        defaults.set(unique, forKey: "loggedInUser")
        print("user logged in: " + unique)
    }
    
    public func getLoggedInUser() -> User? {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "loggedInUser"){
            print("uuid")
            
            return getUser(unique: uuid)
        }else{
            print("Nobody logged in")
            return nil
        }
    }
    
    private func getUser(unique: String) -> User?{
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        userRequest.predicate = NSPredicate(format: "unique == %@", unique)
        do
        {
            let users = try AppDelegate.viewContext.fetch(userRequest)
            
            return users[0]
        }
        catch
        {
            print(error)
            return nil
        }
    }
    
    public static func getAllUsers() -> [User]
    {
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        do
        {
            let users = try AppDelegate.viewContext.fetch(userRequest)
            
            return users
        }
        catch
        {
            print(error)
        }
        return []
    }
    
    private func addUser(lastname: String, firstname:String, password:String, isAdmin:Bool){
        //create new entity in memory
        let uuid: String = NSUUID().uuidString
        
        
        print("Adding Firstname: " + firstname + " Lastname: " + lastname + " Password: " + password + " UUID: " + uuid) //debug
        
        let user = User(context: AppDelegate.viewContext)
        user.firstName = firstname
        user.lastName = lastname
        user.isAdmin = isAdmin
        user.password = password
        user.unique = uuid
        
        
        
        //save to database
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
