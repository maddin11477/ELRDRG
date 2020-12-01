//
//  HttpServer.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.10.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import HttpSwift




public class httpServer
{
    let server = Server()
    public func start()
    {
       
        server.get("/Nachrichten/{id}") { request in
            let index : Int = Int(request.routeParams["id"] ?? "-1") ?? -1
            let nachrichten = DataHandler().getNotifications()
            if index > -1 && index < nachrichten.count
            {
                
                let jsonObject = notificationJsonArray()
                jsonObject.fromArray(notifies: nachrichten)
                return .ok(jsonObject.toJsonString())
                
                
            }
            return .ok("ERROR")
        }
        
       server.get("/Patienten"){ request in
        let encoder = JSONEncoder()
        
        let data = try! encoder.encode(jsonVictim.getJsonVictims())
        let message = String(bytes: data, encoding: .utf8) ?? ""
            return .ok(message)
        }
        
        server.get("/index.html"){ request in
            return .ok("")
        }
        
        
        //notifications in JSON
        server.get("/Nachrichten") { request in
            
            return .ok("")
            
            
        }
        do{
            try server.run()
        }
        catch
        {
            
        }
    }
    
    public func continueworking()
    {
        
    }
    
}






