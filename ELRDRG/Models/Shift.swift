//
//  Shift.swift
//  ELRDRG
//
//  Created by Martin Mangold on 25.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Shift: NSManagedObject , dbInterface{
    public func getID() -> Int32? {
        return self.dbID
    }
    
    public func setID(id: Int32) {
        self.dbID = id
    }

}
