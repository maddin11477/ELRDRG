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
    
    
    
    public func addMission(reason : String?)
    {
        //Neues Objekt initalisieren
        let mission = Mission(context: AppDelegate.viewContext)
        //IDentifier setzen
        mission.unique = UUID().uuidString
        //Besitzer des Objektes festlegen
        mission.user = login.getLoggedInUser()
        //Erstellzeitpunkt festhalten
        mission.start = Date()
        //Einsatzbenennung für GUI
        mission.reason = reason
        //Objekt wird in CoreData gespeichert
        saveData()
        //Objekt benachrichtigt über ein Update der verfügbaren Missions
        delegate?.updatedMissionList(missionList: getAllMissions())
        //Ausgabe für Konsole
        print("Einsatz angelegt: " + mission.reason! + " Unique: " + mission.unique!)
    }
    
   
    
    public func setEndDate()
    {
        let mission = getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        mission.end = Date()
        saveData()
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
    
    public func deleteVictim(victim : Victim)
    {
        let mission = getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        mission.removeFromVictims(victim)
        saveData()
    }
    
    public func getMissionFromUnique(unique : String) -> Mission?
    {
        let userRequest: NSFetchRequest<Mission> = Mission.fetchRequest()
        userRequest.predicate = NSPredicate(format: "unique == %@", unique)
            
            do
            {
                let missions = try AppDelegate.viewContext.fetch(userRequest)
                
                if(missions.count > 0)
                {
                    return missions[0]
                }
                else
                {
                    return nil
                }
                
            }
            catch
            {
                print(error)
                return nil
            }
            
        
    
    }
    
    public func getVictims() -> [Victim]
    {
        let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
        return mission.victims?.allObjects as! [Victim]
    }
    
    public func ceateVictim (age : Int16, category: Int16, firstName : String?, lastName : String?, id : Int16)
    {
        let pat : Victim = Victim(context: AppDelegate.viewContext)
        pat.age = age
        pat.id = id
        pat.category = category
        pat.firstName = firstName
        pat.lastName = lastName
        print("uuid current mission: " + (login.getLoggedInUser()?.currentMissionUnique ?? "nil"))
        
        let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
        mission.addToVictims(pat)
        saveData()
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
