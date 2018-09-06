//
//  UnitHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class UnitHandler: NSObject {

      var delegate : UnitProtocol?
    
    enum UnitType: Int16 {
        case RTW = 0
        case KTW = 1
        case NEF = 2
        case RTH = 3
        case HVO = 4
    }
    public func addBaseUnit(callsign : String, type : UnitType, crewCount : Int16)
    {
        print("Adding Fahrzeug: " + callsign)
        let unit = BaseUnit(context: AppDelegate.viewContext)
        // let unit = Unit(context: AppDelegate.viewContext)
        unit.funkrufName = callsign
        unit.type = type.rawValue
        unit.crewCount = crewCount
        saveData()
        
        
    }
    
    public func deleteBaseUnit(baseUnit : BaseUnit)
    {
        
        AppDelegate.viewContext.delete(baseUnit)
        
        saveData()
        
        
    }
    public func BaseUnit_To_UnitTypeString(id : Int16) -> String
    {
        var value = " "
        switch id {
        case 0:
            value = "RTW"
            break;
        case 1:
            value = "KTW"
            break;
        case 2:
            value = "NEF"
            break;
        case 3:
            value = "RTH"
            break;
        case 4:
            value = "HVO"
        default:
            value = ""
        }
        return value
    }
    
    public func getAllBaseUnits() -> [BaseUnit]
    {
        let userRequest: NSFetchRequest<BaseUnit> = BaseUnit.fetchRequest()
        do
        {
            let baseCars = try AppDelegate.viewContext.fetch(userRequest)
            
            return baseCars
        }
        catch
        {
            print(error)
        }
        return []
    }
    
    public func saveData()
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