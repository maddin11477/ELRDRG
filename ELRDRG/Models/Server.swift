//
//  Server.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 27.04.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData

public protocol serverDelegate {
    func newLog(log:Log)
}

public class Server: NSManagedObject {
    
    public var delegate : serverDelegate?
    
    public func addLog(message:String)
    {
        let log = Log(message: message)
        self.addToLogs(Log(message: message))
        self.delegate?.newLog(log: log)
        
    }
}
