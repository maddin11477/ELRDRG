//
//  Injury.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Injury: NSManagedObject, dbInterface {
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
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: Injury.self))
        }
    }
            
}

extension Injury
{

    public var displayText : String? {
        get
        {
            return (diagnosis ?? " ") + " " + (location?.description ?? " ")
        }
    }
}
