//
//  Mission.swift
//  ELRDRG
//
//  Created by Martin Mangold on 21.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

public class Mission: NSManagedObject, dbInterface {
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
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: Mission.self))
        }
    }
    
    public func endMission()
    {
        if self.end == nil
        {
            self.end = Date()
        }
        
        self.isFinished = true
        if let user = LoginHandler().getLoggedInUser()
        {
            DocumentationHandler().AddTextDocumentation(mission: self, textcontent: "Einsatz / Lage wurde durch \((user.firstName ?? "") + " " + (user.lastName ?? "")) beendet.", savedate: Date())
        }
        else
        {
            DocumentationHandler().AddTextDocumentation(mission: self, textcontent: "Einsatz / Lage wurde durch unbekannt beendet.", savedate: Date())
        }
        DataHandler().saveData()
    }
    
    public func reOpen()
    {
        self.isFinished = false
        if let user = LoginHandler().getLoggedInUser()
        {
            DocumentationHandler().AddTextDocumentation(mission: self, textcontent: "Einsatz / Lage wurde von \((user.firstName ?? "") + " " + (user.lastName ?? "")) erneut geöffnet.", savedate: Date())
        }
        else
        {
            DocumentationHandler().AddTextDocumentation(mission: self, textcontent: "Einsatz / Lage wurde von unbekannt erneut geöffnet.", savedate: Date())
        }
        DataHandler().saveData()
    }
}
