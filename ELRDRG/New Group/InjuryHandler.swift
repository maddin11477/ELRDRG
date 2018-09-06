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
      var delegate : InjuryProtocol?
    
    //ENUM und Array auf gleichem Stand halten !!!!
    public static let locationArray = ["Arm", "Oberschenkel", "Unterschenkel", "Hand", "Abdomen", "Thorax","Kopf"]
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
