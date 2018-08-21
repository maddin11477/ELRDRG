//
//  DataHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class DataHandler: NSObject {
    
    public static  func addFahrzeugToDataBase(funkrufname : String)
    {
        print("Adding Fahrzeug: " + funkrufname)
        let fahrzeug = Fahrzeug(context: AppDelegate.viewContext)
        fahrzeug.funkrufName = funkrufname
        saveData()
        
    }
    
    public static func getAllFahrzeuge() -> [Fahrzeug]
    {
        let userRequest: NSFetchRequest<Fahrzeug> = Fahrzeug.fetchRequest()
        do
        {
            let cars = try AppDelegate.viewContext.fetch(userRequest)
            
            return cars
        }
        catch
        {
            print(error)
        }
        return []
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
    
    public static func saveData()
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
    
    public static func addUser(lastname: String, firstname:String){
        print("Adding Firstname: " + firstname + " Lastname: " + lastname) //debug
        
        //create new entity in memory
        let user = User(context: AppDelegate.viewContext)
        
        user.firstName = firstname
        user.lastName = lastname
        
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
