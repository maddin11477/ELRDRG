//
//  Hospital.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.01.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Hospital: NSManagedObject, dbInterface {
    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }

}
