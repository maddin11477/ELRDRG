//
//  BaseEntity.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 17.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData
public class BaseEntity : NSManagedObject
{
    private static func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    
    //move to session handler
    //Replace with optimized function
    public func loggInUser(user: User){
        let defaults = UserDefaults.standard
        defaults.set(user.unique, forKey: "loggedInUser")
        print("user logged in: \(String(describing: user.unique))")
    }
}
