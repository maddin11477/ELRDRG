//
//  dbIDManager.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 18.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData

public class dbManager
{
    static func refreshAlldbIDs()
    {
       
        
        NSManagedObject.refreshIDs(entity: Documentation.self)
        NSManagedObject.refreshIDs(entity: User.self)
        NSManagedObject.refreshIDs(entity: Attachment.self)
        NSManagedObject.refreshIDs(entity: Mission.self)
        NSManagedObject.refreshIDs(entity: Victim.self)
        NSManagedObject.refreshIDs(entity: Section.self)
        NSManagedObject.refreshIDs(entity: Unit.self)
        NSManagedObject.refreshIDs(entity: Injury.self)
        NSManagedObject.refreshIDs(entity: BaseInjury.self)
        NSManagedObject.refreshIDs(entity: BaseHospital.self)
        NSManagedObject.refreshIDs(entity: BaseUnit.self)
        NSManagedObject.refreshIDs(entity: Shift.self)
        NSManagedObject.refreshIDs(entity: Hospital.self)
        NSManagedObject.refreshIDs(entity: Notification.self)
        NSManagedObject.refreshIDs(entity: DocumentationTemplate.self)
      
        
        
    }
}

public protocol dbInterface
{
    func setID(id : Int32)
    func getID()->Int32?
}

extension NSManagedObject{
  
   
    
    public static func refreshIDs<T:NSManagedObject>(entity: T.Type) ->[T]?
    {
        print("Entity Type:")
        print(String(describing: T.self))
        let userRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        do
        {
            let objects = try AppDelegate.viewContext.fetch(userRequest)
            if let objList = objects as? [dbInterface]
            {
                var nextIndex = getNextID(objects: objList)
                var zeroCounter = 0
                for o in objList
                {
                    if o.getID() == 0
                    {
                        zeroCounter = zeroCounter + 1
                    }
                }
                if zeroCounter > 1
                {
                    for o in objList
                    {
                        o.setID(id: -1)
                    }
                }
                nextIndex = getNextID(objects: objList)
                for o in objList {
                    print(o.getID())
                    if o.getID() == nil || o.getID() == -1
                    {
                        o.setID(id: nextIndex)
                        nextIndex = nextIndex + 1
                    }
                }
                return objects
            }
            
            
            return nil
        }
        catch
        {
            return nil
        }
        
    }
    
    static func getNextID(objects : [dbInterface])->Int32
    {
        
        let sortedObjects = objects.sorted(by: {
            ($0.getID() ?? -1) < ($1.getID() ?? -1)
        })
        if sortedObjects.count == 0
        {
            return 0
        }
        return (sortedObjects[sortedObjects.count - 1].getID() ?? -1) + 1
    }
    
  
}
