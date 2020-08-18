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
		//mission als nicht beendet markieren
		mission.isFinished = false
        //Objekt wird in CoreData gespeichert
        saveData()
        //Objekt benachrichtigt über ein Update der verfügbaren Missions
		delegate?.updatedMissionList(missionList: getAllMissions(missions: true))


        //Ausgabe für Konsole
        print("Einsatz angelegt: " + mission.reason! + " Unique: " + mission.unique!)
    }
    
   
    
    public func setEndDate()
    {
        //let mission = getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        //mission.end = Date()
        saveData()
    }
    
	
    
	public func getAllMissions(missions : Bool?) -> [Mission]
    {
		let user = LoginHandler().getLoggedInUser()
        let missionRequest : NSFetchRequest<Mission> = Mission.fetchRequest()
        do
        {
            var missionList = try AppDelegate.viewContext.fetch(missionRequest)
			if let ownMission = missions
			{
				if ownMission
				{
					missionList = missionList.filter{
						$0.user?.callsign == user?.callsign
					}
				}
				else
				{
					missionList = missionList.filter{
						$0.user?.callsign != user?.callsign
					}
				}

			}


				//$0.user == user

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
    
	public func createUser(password : String, firstname : String, lastname : String, isAdmin : Bool, eMail : String, phone : String, callsign : String)-> Int
    {
        //0 == already exists, 1 == true, -1 == wrong input values
        if(password != "" && firstname != "" && lastname != "")
        {
            let loginHandler = LoginHandler()
            
            let userList = loginHandler.getAllUsers()
            var alreadyExists : Bool = false
            for  user : User in userList {
                if(user.firstName == firstname || user.lastName == lastname)
                {
                    alreadyExists = true
                }
            }
            if(alreadyExists)
            {
                return -1
            }
            
            let user = User(context: AppDelegate.viewContext)
                   user.firstName = firstname
                   user.lastName = lastname
                   user.isAdmin = isAdmin
                   user.password = password
                    user.unique = UUID().uuidString
                    user.phone = phone
                    user.eMail = eMail
			user.callsign = callsign
                   
                   
                   
                   saveData()
            return 1
        }
        else
        {
            return 0
        }
        
    }


	public func deleteMission(mission : Mission)
	{
		AppDelegate.viewContext.delete(mission)
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

	public func getCurrentMission()-> Mission?
	{
		if let currentMissionUnique = login.getLoggedInUser()?.currentMissionUnique
		{
			return getMissionFromUnique(unique: currentMissionUnique)
		}
		return nil
		//return let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)
	}
    
    public func ceateVictim (age : Int16, category: Int16, firstName : String?, lastName : String?)
    {

		let victims = DataHandler().getVictims()
		var id = 0
		for vic in victims {
			if vic.id >= id
			{
				id = Int(vic.id)
			}
		}
		id = id + 1
		let pat : Victim = Victim(context: AppDelegate.viewContext)
        pat.age = age
        pat.id = Int16(id)
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
