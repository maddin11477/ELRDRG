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
   
    let login : LoginHandler = LoginHandler()
    
    var delegate : missionProtocol?
    
    public func addBaseUnit(callsign : String, type : String, crewCount : Int16)
    {
        print("Adding Fahrzeug: " + callsign)
        let unit = BaseUnit(context: AppDelegate.viewContext)
       // let unit = Unit(context: AppDelegate.viewContext)
        unit.funkrufName = callsign
        unit.type = type
        unit.crewCount = crewCount
        saveData()
        
        
    }
    
    public func addMission(reason : String?)
    {
        let mission = Mission(context: AppDelegate.viewContext)
        mission.user = login.getLoggedInUser()
        mission.start = Date()
        mission.reason = reason
        saveData()
        delegate?.updatedMissionList(missionList: getAllMissions())
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
    
    public func getAllMissions() -> [Mission]
    {
        let missionRequest : NSFetchRequest<Mission> = Mission.fetchRequest()
        do
        {
            let missionList = try AppDelegate.viewContext.fetch(missionRequest)
            return missionList
        }
        catch
        {
            print(error)
        }
        return []
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
