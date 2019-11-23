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
    
    //move to session handler
    //Replace with optimized function
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
    
    //move to session handler
    //Replace with optimized function
    public func loggInUser(user: User){
        let defaults = UserDefaults.standard
        defaults.set(user.unique, forKey: "loggedInUser")
        print("user logged in: \(String(describing: user.unique))")
    }
    
    //moved to session handler
    //Replace with optimized function
    public func loggOffUser(){
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "loggedInUser")
    }
    
    //moved to session handler
    //Replace with optimized function
    public func getLoggedInUser() -> User? {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "loggedInUser"){
            print("uuid: \(uuid)")
            
            return getUser(unique: uuid)
        }else{
            print("Nobody logged in")
            return nil
        }
    }
    
    //moved to session handler
    //Replace with optimized function
    public func getLoggedInUserName() -> String {
        let defaults = UserDefaults.standard
        var combinedusername = ""
        if let uuid = defaults.string(forKey: "loggedInUser"){
            print("uuid: \(uuid)")
            if let user = getUser(unique: uuid){
                let last = user.lastName!
                let first = user.firstName!
                combinedusername = "\(last), \(first)"
            }
        }
        return combinedusername
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
    
    public func getAllUsers() -> [User]
    {
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        do
        {
            let users = try AppDelegate.viewContext.fetch(userRequest)
            print("User anzahl:")
            print(users.count)
            return users
        }
        catch
        {
            print(error)
        }
        return []
    }
    
    public func setCurrentMissionUnique(unique: String?)
    {
        let user = getLoggedInUser()
        if let _ = unique
        {
            user?.currentMissionUnique = unique
        }
        else
        {
            user?.currentMissionUnique = nil
        }
        
       
        saveData()
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
        
        
        
        saveData()
    }
    
    private func saveData()
    {
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
