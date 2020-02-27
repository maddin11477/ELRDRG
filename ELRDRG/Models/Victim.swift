//
//  Victim.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Victim: NSManagedObject {
}

extension Victim
{

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
}

