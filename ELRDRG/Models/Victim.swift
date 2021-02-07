//
//  Victim.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Victim: NSManagedObject, Encodable, dbInterface {
    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }
    
    convenience init() {
        self.init()
        if self.dbID == -1
        {
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: Victim.self))
        }
    }
}


public class jsonVictim : NSObject, Codable {
    public var name : String?
    public var firstName : String?
    public var age : Int?
    public var hospital : String?
    public var units : [String]?
    public var category : Int?
    public var injuries : [String]?
    public var isDone : Bool?
    public var ID : Int!
    public var schockraum : Bool?
    public var stable : Bool?
    public var hospitalClearance : Int?
    public var birthdate : String?
    public var additionalInfo : String?
    public var gender : Int?
    
    public static func getJsonVictims()->[jsonVictim]
    {
        var array : [jsonVictim] = []
        
        for victim in DataHandler().getVictims() {
            array.append(victim.toJsonObject())
        }
        return array
    }
    
}

extension Victim
{
    public func toJsonString()->String
    {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        let jsonString = String(data: data, encoding: .utf8)!
        
        return jsonString
    }
    
    public func toJsonObject()->jsonVictim
    {
        let object : jsonVictim = jsonVictim()
        object.name = self.lastName
        object.firstName = self.firstName
        object.age = Int(self.age)
        object.hospital = self.hospital?.name
        if let units = self.getUnits()
        {
            object.units = []
            for unit in units {
                object.units?.append(unit.callsign ?? "Template Unit")
            }
        }
        object.category = Int(self.category)
        object.isDone = !(self.isDone == nil)
        object.ID = Int(self.id)
        object.schockraum = self.schockraum
        object.stable = self.stabil
        object.hospitalClearance = Int(self.hospitalClearance)
        
        object.additionalInfo = self.additionalIfnormation
        if let injuries = self.verletzung?.allObjects as? [Injury]
        {
            object.injuries = []
            for injury in injuries {
                object.injuries?.append(injury.diagnosis ?? "")
            }
        }
        if let date = self.birthdate
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            object.birthdate = formatter.string(from: date)
        }
        object.gender = Int(self.gender)
        return object
    
    }

    public func setHospitalInfoState(hospitalState state : Int)
    {
		self.hospitalClearance = Int16(state)
        DataHandler().saveData()
    }
    
    public func getHospitalInfoState()->String
    {
        switch self.hospitalClearance {
        case 0:
            return ""
        case 1:
            return "KH angefragt"
        case 2:
            return "Pat. angemeldet"
        default:
            return "KH nicht angefragt"
        }
    }
    
    public func getHospitalInfoState()->Bool
    {
        if(self.hospitalClearance == 2)
        {
            return true
        }
        return false
    }

	func checkDoublePatID() -> Bool
	{
		let victims = DataHandler().getVictims()
		var isDouble = false
		for vic in victims {
			if (vic != self && vic.id == self.id)
			{
				isDouble = true
				break
			}
		}

		return isDouble
	}

    public func getHospitalInfoState()->UIColor
    {
        switch self.hospitalClearance {
        case 0:
            return UIColor(named: "UIBackcolor_NEW") ?? UIColor.red
        case 1:
            return UIColor.orange
        case 2:
            return UIColor.green
        default:
            return UIColor(named: "UIBackcolor_NEW") ?? UIColor.red
        }
    }
    
    public func getHospitalInfoState()->Int
    {
        return Int(self.hospitalClearance)
    }

	public func getUnits()-> [Unit]?
	{
		if let units = self.fahrzeug?.allObjects as? [Unit]
		{
			return units
		}
		return nil
	}
}

