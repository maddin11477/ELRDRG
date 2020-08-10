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
        case all = -1
        case RTW = 0
        case KTW = 1
        case NEF = 2
        case RTH = 3
        
        case Sonstiges = 4
        case Krad = 5
        case kdow = 6
        
        case MTW = 7
        case LKW = 8
        case KTWkats = 9
        case wasserwacht = 10
        case elw = 11
    }
    
    public func getUsedUnits(UnitType type : UnitType = .all) -> [Unit]
    {
		
        var units : [Unit] = []
        let sections = SectionHandler().getSections()
        let patients = DataHandler().getVictims()
        for section in sections {
            if let _units = section.units?.allObjects as? [Unit]
            {
                //Nur Units die keinen Patienten haben, units die patienten haben werden anschließend aus Patienten gelesen (sonst doppelt)
				print(_units.count)
				print("vorher:")
				print(units.count)
                units += _units.filter({
					if let victims = $0.patient?.allObjects as? [Victim] {
						if(victims.count > 0)
						{
							return false
						}
						else
						{
							return true
						}

                    }
                    return true
                })
				print("nachher:")
				print(units.count)
            }
        }
        
        for patient in patients
        {
            if let _units = patient.fahrzeug?.allObjects as? [Unit]
            {
				for car in _units
				{
					if units.contains(car) == false
					{
						units.append(car)
					}
				}
               // units += _units
            }
        }
        if(type == .all)
        {
            return units
        }
        else
        {
            return units.filter({$0.type == type.rawValue})
        }
        
    }


	public func getFreeUsedUnits(UnitType type : UnitType = .all)->[Unit]
	{
		let units = getUsedUnits(UnitType: type).filter({
			if let victims = $0.patient?.allObjects as? [Victim]
			{
				if(victims.count > 0)
				{
					return false
				}
			}
			return true
		})
		return units
	}

    
    
    public func addBaseUnit(callsign : String, type : UnitType, crewCount : Int16) -> BaseUnit
    {
        print("Adding Fahrzeug: " + callsign)
        let unit = BaseUnit(context: AppDelegate.viewContext)
        // let unit = Unit(context: AppDelegate.viewContext)
        unit.funkrufName = callsign
        unit.type = type.rawValue
        unit.crewCount = crewCount
        saveData()
        return unit
        
    }
    
    public func baseUnit_To_Unit(baseUnit : BaseUnit) -> Unit
    {
        let unit = Unit(context: AppDelegate.viewContext)
        unit.callsign = baseUnit.funkrufName
        unit.crewCount = baseUnit.crewCount
        unit.type = baseUnit.type
        return unit
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
            value = "Sonstiges"
        case 5:
            value = "Krad"
        case 6:
            value = "Kdow"
        case 7:
            value = "MTW"
        case 8:
            value = "LKW"
        case 9:
            value = "Kat-KTW"
        case 10:
            value = "Wasserwacht"
        case 11:
            value = "ELW"
        default:
            value = "sonstiges"
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

	public func getUnusedBaseUnits(unittype : UnitType = .all) -> [BaseUnit]
	{
		//gibt alle BaseUnits zurück, die noch nicht in verwendung sind
		var returnList : [BaseUnit] = []
		let baseUnits = getAllBaseUnits()
		let usedUnits = getFreeUsedUnits()
		for baseUnit in baseUnits
		{
			var isAvailable = false
			for  unit in usedUnits {
				if unit.callsign == baseUnit.funkrufName
				{
					isAvailable = true
				}
			}
			if isAvailable == false
			{
				returnList.append(baseUnit)
			}
		}
		if unittype != .all
		{
			returnList = returnList.filter(){
				$0.type == unittype.rawValue
			}
		}
		return returnList
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
