//
//  BaseDataHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 04.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//
import CoreData
import UIKit

class BaseDataHandler: NSObject {
 //Handelt Stammdaten
    
    
    var delegate : StammdatenProtocol?
    //UNit enum
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
    
    public func deleteBaseHospital(basehospital : BaseHospital)
    {
        AppDelegate.viewContext.delete(basehospital)
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
    
    
    public func addBaseHospital(name : String, city : String)
    {
        let hospital = BaseHospital(context: AppDelegate.viewContext)
        hospital.name = name
        hospital.city = city
        saveData()
    }
    
    public func getAllHospitals() -> [BaseHospital]
    {
        let userRequest : NSFetchRequest<BaseHospital> = BaseHospital.fetchRequest()
        do
        {
           let basehospitals = try AppDelegate.viewContext.fetch(userRequest)
            return basehospitals
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
