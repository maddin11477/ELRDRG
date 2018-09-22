//
//  InjuryHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData
class InjuryHandler: NSObject {
      public var delegate : InjuryProtocol?
    
    //ENUM und Array auf gleichem Stand halten !!!!
    public static let locationArray = ["Arm", "Oberschenkel", "Unterschenkel", "Hand", "Abdomen", "Thorax","Kopf"]
    
    public func sideToString(side : side?) -> String
    {
        if let bodyside = side
        {
            if(bodyside == .left)
            {
                return "links"
            }
            else if(bodyside == .right)
            {
                return "rechts"
            }
        }
        
            return ""
        
       
        
    }
    
    enum side : Int16
    {
        case left = 0
        case right = 1
    }
    enum locations: Int16
    {
        
        case Arm = 0
        case Oberschenkel = 1
        case Unterschenkel = 2
        case Hand = 3
        case Abdomen = 4
        case Thorax = 5
        case Kopf = 6
        
    }
    
    public func convertToInjury( baseInjury : BaseInjury) -> Injury
    {
        let injury = Injury(context: AppDelegate.viewContext)
        injury.category = baseInjury.category
        injury.diagnosis = baseInjury.diagnosis
        injury.location = baseInjury.loaction
        return injury
    }
    
    
    public func addBaseInjury(diagnose : String, location : String, category : Int16)
    {
        print("created")
        
        let injury = BaseInjury(context: AppDelegate.viewContext)
        // let unit = Unit(context: AppDelegate.viewContext)
        injury.category = category
        injury.diagnosis = diagnose
        injury.loaction = location
        
        saveData()
        
        
    }
    
    public func deleteBaseInjury(baseInjury : BaseInjury)
    {
        
        AppDelegate.viewContext.delete(baseInjury)
        
        saveData()
        
        
    }
    
    public func deleteInjury(injury : Injury)
    {
        AppDelegate.viewContext.delete(injury)
        saveData()
    }
    
    public func getAllBaseInjury() -> [BaseInjury]
    {
        let userRequest: NSFetchRequest<BaseInjury> = BaseInjury.fetchRequest()
        do
        {
            let baseInjury = try AppDelegate.viewContext.fetch(userRequest)
            
            return baseInjury
        }
        catch
        {
            print(error)
        }
        return []
    }
    
    public func saveData()
    {
        //save to database
        do
        {
            try AppDelegate.viewContext.save()
        }
        catch
        {
            print(error)
        }
    }
}
