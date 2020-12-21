//
//  Unit.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Unit: NSManagedObject , dbInterface{
}

extension Unit{

    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }
    
    public func getVictimCount() -> Int{
        if let victimList = self.patient?.allObjects as? [Victim]
        {
            return victimList.count
        }
        return 0
    }
    public func hasDestination() -> Bool
    {
        if let victimList = self.patient?.allObjects as? [Victim]
        {
            for vic in victimList
            {
                if let _ = vic.hospital
                {
                    return true
                }
            }
        }
        return false
    }
    
    public func getDestination() -> Hospital?
    {
        if let victimList = self.patient?.allObjects as? [Victim]
        {
            for vic in victimList
            {
                if let hospital = vic.hospital
                {
                    return hospital
                }
            }
        }
        
        return nil
    }

	public func getVictims()->[Victim]?
	{
		if let victims = self.patient?.allObjects as? [Victim]
		{
			return victims
		}
		return nil
	}
    
    
    
    //Gibt die schwerwiegenste Kategorie zurück
    public func getGlobalCategory()->Int16?
    {
        var category : Int16 = 10
        if let victimList = self.patient?.allObjects as? [Victim]
        {
            for vic in victimList
            {
                if vic.category < category
                {
                    category = vic.category
                }
            }
        }
        return nil
    }
    
    
}
    

