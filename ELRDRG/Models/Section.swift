//
//  Section.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public protocol SectionDelegate{
	func DroppedUnit(unit : Unit)
	func DroppedPattern(pattern : UnitPattern)
	func DroppedVictim(victim : Victim)
	func SectionChanged(section : Section)

}

public enum UnitType: Int16 {
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

public class Section: NSManagedObject, dbInterface {
	public var delegate : SectionDelegate?
    public var mapAnnotation : SectionMapAnnotation?
    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }
}

extension Section {
    
   

	public func getPatterns() -> [UnitPattern]
	{
		if let units = self.units?.allObjects as? [Unit]
		{
			var patterns : [UnitPattern] = []
			for unit in units {
				if let pat = UnitPattern.checkForPattern(unit: unit)
				{
					var available = false
					for av_pat in patterns  {
						if av_pat.victim == pat.victim
						{
							available = true
						}
					}
					if !available
					{
						patterns.append(pat)
					}
				}
			}
			return patterns
		}
		else
		{
			return []
		}
	}

	/// To get all victims which are currently based in this section on their own, you have to set the parameter **all** to **True**
	/// Otherwise the list will be filtered by the victims already included in the patterns
	///
	public func getVictims(all : Bool =  false) -> [Victim]
	{

		if var victims = self.victims?.allObjects as? [Victim]
		{
			if !all //Filtering all victims which are already included in Patterns from Victimlist
			{
				let patterns = getPatterns()
				for pattern in patterns {
					if let index = victims.index(of: pattern.victim)
					{
						if index > -1
						{
							victims.remove(at: index)
						}
					}
				}
			}
			victims = victims.sorted(by: {
				$1.id > $0.id
			})
			return victims
		}
		return []
	}

	public func getUnits()->[Unit]
	{
		var returnList : [Unit] = []

		if var units = self.units?.allObjects as? [Unit]
		{
			units = units.filter{ !UnitPattern.checkForPattern(unit: $0) }
			returnList.append(contentsOf: units)
		}


		return returnList

	}
    
    public func getAllUnits()->[Unit]
    {
        var returnList : [Unit] = []
        if let units = self.units?.allObjects as? [Unit]
        {
            returnList = units
        }
        return returnList
    }
    
	public func getUnitbyType(type : UnitType)->[Unit]
	{
		var units = getUnits()
		for pattern in self.getPatterns() {
			units.append(contentsOf: pattern.units)
		}

		units = units.filter{
			$0.type == type.rawValue
		}
		return units

	}


/// **pattern** : *UnitPattern* is the dropped pattern
	public func droppedPattern(pattern : UnitPattern)
	{
		for unit in pattern.units
		{
			//Remove all section relation of patterns units
			if let sec = unit.section
			{
				sec.removeFromUnits(unit)
			}
			unit.section = nil
            
			if let secUnits = self.units?.allObjects as? [Unit]
			{
				if !secUnits.contains(unit)
				{
					self.addToUnits(unit)
				}
			}
			else
			{
				self.addToUnits(unit)
			}
			unit.section = self

		}

		pattern.victim.section = nil
		let handler = UnitHandler()
		handler.saveData()

		self.delegate?.DroppedPattern(pattern: pattern)
		self.delegate?.SectionChanged(section: self)

	}

	public func droppedUnit(unit : Unit)
	{
		unit.section = self
		if !getUnits().contains(unit)
		{
			self.addToUnits(unit)
		}
		self.delegate?.DroppedUnit(unit: unit)
		self.delegate?.SectionChanged(section: self)
	}

	public func droppedVictim(victim : Victim)
	{
		victim.section = self

		self.delegate?.DroppedVictim(victim: victim)
		self.delegate?.SectionChanged(section: self)
	}

	public func getUnitSeperationCounter()
	{
		/*
		//------- UNITS

		/*
		case RTW = 0
		case KTW = 1
		case NEF = 2
		case RTH = 3
		case HVO = 4
		*/
		let units = (self.units).sorted(by: { $0.callsign!.lowercased() < $1.callsign!.lowercased() })
		for unit in units
		{
			if(unit.type == 0)
			{
				//RTW
				anzahlRTW = 1 + anzahlRTW
			}
			else if(unit.type == 1)
			{
				//KTW
				anzahlKTW = 1 + anzahlKTW
			}
			else if(unit.type == 2)
			{
				anzahlNEF = 1 + anzahlNEF
			}
			else if(unit.type == 3)
			{
				anzahlRTH = 1 + anzahlRTH
			}
			else if(unit.type == 4)
			{
				anzahlSonstige = 1 + anzahlSonstige
			}
			lblKTW.text = "KTW: " + String(anzahlKTW)
			lblRTH.text = "RTH: " + String(anzahlRTH)
			lblRTW.text = "RTW: " + String(anzahlRTW)
			lblNEF.text = "NEF: " + String(anzahlNEF)

		}

		if(anzahl == 0)
		{
			lblKTW.text = "KTW: 0"
			lblNEF.text = "NEF: 0"
			lblRTH.text = "RTH: 0"
			lblRTW.text = "RTW: 0"
		}
		*/
	}
}
