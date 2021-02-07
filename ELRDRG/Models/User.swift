//
//  User.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class User: NSManagedObject, dbInterface{
    
    public func getID() -> Int32? {
        return self.dbID
    }
    
    convenience init() {
        self.init()
        if self.dbID == -1
        {
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: User.self))
        }
    }
    
    
    
    public func setID(id: Int32) {
        self.dbID = id
    }
}
