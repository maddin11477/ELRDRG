//
//  BaseHospital.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class BaseHospital: NSManagedObject, Comparable, dbInterface{
    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }
}

extension BaseHospital{
	public static func < (lhs: BaseHospital, rhs: BaseHospital) -> Bool {
		return lhs.distance < rhs.distance
	}


	public var distance : Double {
		get{
			return LocationHandler.shared().getDistance(RemoteLocation: self.lat, RemoteLocation: self.lng)		
		}
	}

	
}
