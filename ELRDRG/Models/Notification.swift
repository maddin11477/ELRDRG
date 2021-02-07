//
//  Notification.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.10.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import CoreData

public class jsonNotification : Codable {
    public var sender : String = ""
    public  var content : String = ""
    public  var ackknowledged : Bool = false
    public var time : String = ""
    public var date : String = ""
}

public class notificationJsonArray : NSObject, Codable{
    public var notifications : [jsonNotification] = []
    
    public func fromArray(notifies : [Notification])
    {
        for notify in notifies {
            notifications.append(notify.toJsonObject())
            
        }
    }
    
    public func toJsonString()->String
    {
        let encoder = JSONEncoder()
               do{
                   let data = try encoder.encode(self)
                   let jsonString = String(data: data, encoding: .utf8)!
                   
                   
                   return jsonString
               }
               catch
               {
                   print(error)
               }
               
               return ""
    }
    public func toJsonObject()->Data?
    {
        let encoder = JSONEncoder()
               do{
                   let data = try encoder.encode(self)
                   
                   
                   
                   return data
               }
               catch
               {
                   print(error)
               }
               
               return nil
    }
}

public class Notification: NSManagedObject, dbInterface {
    
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
            self.dbID = NSManagedObject.getNextID(objects: NSManagedObject.getAll(entity: Notification.self))
        }
    }
    
    public func toJsonObject()-> jsonNotification
    {
        let notification = jsonNotification()
        notification.sender = self.sender ?? ""
        notification.content = self.content ?? ""
        notification.ackknowledged = self.acknowledged
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "dd.MM.yyyy"
        notification.date = customFormatter.string(for: Date()) ?? ""
        customFormatter.dateFormat = "HH:mm"
        notification.time = customFormatter.string(for: Date()) ?? ""
        return notification
        
    }
    
    public func toJsonString()->String
    {
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(self.toJsonObject())
            let jsonString = String(data: data, encoding: .utf8)!
            
            
            return jsonString
        }
        catch
        {
            print(error)
        }
        
        return ""
        
        
    }
    
    
    
}

@objc public protocol NotificationDelegate {
    @objc optional func refreshNotifications(notifications : [Notification])
    @objc optional func NotificationChanged(notification : Notification)
}
