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
    
    func getThumbnail()->UIImage?
    {
        let documents = self.documentations?.allObjects as? [Documentation] ?? []
        //If a picture is marked as thumbnail
        for docu in documents {
            if docu.thumbnail
            {
                let attachments = docu.attachments?.allObjects as! [Attachment]
                if attachments.count > 0
                {
                    return DocumentationHandler().getImage(pictureName: attachments[0].uniqueName!)
                }
                
                
            }
        }
        
        //no Image marked as Thumbnail
        for docu in documents {
            let attachments = docu.attachments?.allObjects as! [Attachment]
            if attachments.count > 0 && attachments[0].type == DocumentationType.Photo.rawValue
            {
                return DocumentationHandler().getImage(pictureName: attachments[0].uniqueName!)
            }
        }
        
        //if no photo is availabel
        return nil
        
    }
    
    private var dataHandler = DataHandler()
    
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
        self.dataHandler.saveData()
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
        self.dataHandler.saveData()
    }
    
    public func save()
    {
        do{
            try! AppDelegate.viewContext.save()
        }
        
       
    }
}
