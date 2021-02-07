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
  
    public static func getAll<T:NSManagedObject>(entity: T.Type)->[dbInterface]
    {
        let userRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        do
        {
            //Es werden alle Objekte des Types T geladen
            let objects = try AppDelegate.viewContext.fetch(userRequest)
            
            /* Es werden alle Objekte in den Typen *dbInterface* gecastet um eine Schnittstelle zu bekommen:
             * Hier wurde absichtlich keine Elternklasse als Schnittstelle eingeführt, damit bisher erstellte Datenbankeinträge nicht verloren gehen und protocol orientierte programmierung notwendig ist
             */
            if let objList = objects as? [dbInterface]
            {
                return objList
            }
            else {
                return []
            }
            
            
        }catch {
            return []
        }
    }
    
    public static func refreshIDs<T:NSManagedObject>(entity: T.Type)
    {
        print("Entity Type:")
        print(String(describing: T.self))
        
        //Liest alle Objekte des T Types und gibt Sie als dbInterface zurück
        let objList = getAll(entity: T.self)
            
        print(T.self)
        //auslesen der einzelnen dbIDs um die höchste dbID zurück zu geben
        var nextIndex = getNextID(objects: objList)
        var zeroCounter = 0
        
        //Da bisheriger default value des dbIDs parameter 0 war, muss jede entity liste überprüft werden, dass die Nullen geupdeted wurden und nurnoch 1x vorkommen -> quasi jede dbID unique ist
        for o in objList
        {
            if o.getID() == 0
            {
                zeroCounter = zeroCounter + 1
            }
        }
        
        //Wenn die 0 doppelt vorkommt wurde die Entity noch nicht aufbereitet daher werden alle dbIDs resettet zu -1
        if zeroCounter > 1
        {
            for o in objList
            {
                o.setID(id: -1)
            }
        }
        
        //Alle Objekte mit einer dbID == -1 oder nil bekommen eine neue dbID
        nextIndex = getNextID(objects: objList)
        for o in objList {
            print(Int32(o.getID() ?? -1))
            if o.getID() == nil || o.getID() == -1
            {
                o.setID(id: nextIndex)
                nextIndex = nextIndex + 1
            }
        }
    }
    
    
    /*
     Aus allen Objekten werden die dbIDs zurück gelesen und die größte dbID + 1 als nächste dbID zurück gegeben
     */
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
