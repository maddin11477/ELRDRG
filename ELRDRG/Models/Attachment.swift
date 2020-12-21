//
//  TextDocumentation.swift
//  ELRDRG
//
//  Created by Martin Mangold on 24.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Attachment: NSManagedObject, dbInterface {
    public func getID() -> Int32? {
        return self.dbID as! Int32
    }
    
    public func setID(id: Int32) {
        self.dbID = NSNumber(value: id)
    }
}
