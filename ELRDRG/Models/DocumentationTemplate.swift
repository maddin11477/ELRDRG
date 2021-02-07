//
//  DocumentationTemplate.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData


public class DocumentationTemplate: NSManagedObject, dbInterface {
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
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: DocumentationTemplate.self))
        }
    }
            
    
    public func increment()
    {
        self.useCounter = self.useCounter + 1
        DataHandler().saveData()
    }
}
