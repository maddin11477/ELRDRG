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
