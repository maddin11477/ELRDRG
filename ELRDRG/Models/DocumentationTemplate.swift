//
//  DocumentationTemplate.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData


public class DocumentationTemplate: NSManagedObject {
    public func increment()
    {
        self.useCounter = self.useCounter + 1
        DataHandler().saveData()
    }
}
