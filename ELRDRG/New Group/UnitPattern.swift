//
//  UnitPattern.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 08.07.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

public class UnitPattern: NSObject {

	public var victim : Victim = Victim()
	public var units : [Unit] = []

	init(victim : Victim) {
		
		self.victim = victim
		self.units = victim.getUnits() ?? []
		var section : Section?
		for unit  in self.units {
			if let sec = unit.section
			{

					section = sec

			}
		}
		for unit in self.units
		{
			unit.section = section
		}


	}

	public static func generatePattern(newVictim : Victim) -> UnitPattern?
	{
		let canGeneratePattern = checkForPattern(newVictim: newVictim)
		if canGeneratePattern == true
		{
			return UnitPattern(victim : newVictim)
		}

		return nil
	}




	public static func checkForPattern(unit : Unit) -> Bool
	{
		var canGeneratePattern : Bool = false



		if let victims = unit.getVictims()
		{
			if victims.count == 1 && checkForPattern(newVictim: victims[0])
			{
				canGeneratePattern = true
			}
		}
		return canGeneratePattern
	}

	public static func checkForPattern(unit : Unit) -> UnitPattern?
	{
		if let victims = unit.getVictims()
		{
			if victims.count == 1 && checkForPattern(newVictim: victims[0])
			{
				return generatePattern(newVictim: victims[0])
			}
		}
		return nil
	}

	public static func checkForPattern(newVictim : Victim) -> Bool
	{
		var canGeneratePattern : Bool = true
		// get all units which are related to this victim
		if let units = newVictim.getUnits()
		{
			//only continue when more then one unit is related, otherwise its usual handling
			if units.count > 1
			{
				//Check if each related unit does not have a relation to other victims
				for car in units {
					if let vics = car.getVictims()
					{
						if vics.count != 1 || vics[0] != newVictim
						{
							canGeneratePattern = false
						}
					}
				}
			}
			else
			{
				canGeneratePattern = false
			}



		}
		else
		{
			canGeneratePattern = false
		}


		return canGeneratePattern
	}


}
