//
//  Log.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 27.04.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import CoreData
import Foundation

public class Log: NSManagedObject {
    
   
    
    convenience init(message:String) {
        self.init()
        self.message = message
        self.date = Date()
    }
}

public extension Date {
    func ToShortDateString()->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: self)
    }
    
    func ToShortTimeString()->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: self)
    }
    
    func ToLongDateString()->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    func ToLongTimeString()->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter.string(from: self)
    }
}
