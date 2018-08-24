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
    
    public static  func addFahrzeugToDataBase(callsign : String)
    {
        print("Adding Fahrzeug: " + callsign)
        let unit = Unit(context: AppDelegate.viewContext)
        unit.callsign = callsign
        saveData()
        
    }
    
    public static func getAllFahrzeuge() -> [Unit]
    {
        let userRequest: NSFetchRequest<Unit> = Unit.fetchRequest()
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
    
    
}
