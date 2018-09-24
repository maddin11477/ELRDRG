//
//  SectionHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

protocol SectionProtocol {
    func createdBaseSection()
}
class SectionHandler: NSObject {
    
    public var delegate : SectionProtocol?
    let login = LoginHandler()
    
    public func deleteBaseSection(basesection : BaseSection)
    {
        AppDelegate.viewContext.delete(basesection)
        saveData()
    }
    
    
    public func getMissionFromUnique(unique : String) -> Mission?
    {
        let userRequest: NSFetchRequest<Mission> = Mission.fetchRequest()
        userRequest.predicate = NSPredicate(format: "unique == %@", unique)
        
        do
        {
            let missions = try AppDelegate.viewContext.fetch(userRequest)
            
            if(missions.count > 0)
            {
                return missions[0]
            }
            else
            {
                return nil
            }
            
        }
        catch
        {
            print(error)
            return nil
        }
        
        
        
    }
    
    public func deleteBaseInjury(baseInjury : BaseInjury)
    {
        
        AppDelegate.viewContext.delete(baseInjury)
        
        saveData()
        
        
    }
    
    public func getSections() -> [Section]
    {
        let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
         var array =  mission.sections?.allObjects as! [Section]
        array.sort(by: { $0.id < $1.id})
        
        return array
    }
    
  
    
    public func addSection(identifier : String)
    {
         let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
        let section = Section(context: AppDelegate.viewContext)
        section.identifier = identifier
        var highest = 0
        for sec in mission.sections?.allObjects as! [Section]
        {
            if sec.id > highest
            {
                highest = Int(sec.id)
            }
        }
        section.id = Int16(highest + 1)
        mission.addToSections(section)
        saveData()
    }
    
    public func BaseSection_to_Section(baseSection : BaseSection) -> Section
    {
        let section = Section(context: AppDelegate.viewContext)
        section.identifier = baseSection.identifier
        
        return section
    }
    
    
    
    
    public func addBaseSection(identifier : String) -> BaseSection
    {
        let section = BaseSection(context: AppDelegate.viewContext)
        section.identifier = identifier
        saveData()
        return section
    }
    
    public func getAllSections() -> [BaseSection]
    {
        let baseSectionRequest : NSFetchRequest<BaseSection> = BaseSection.fetchRequest()
        do
        {
            let basesections = try AppDelegate.viewContext.fetch(baseSectionRequest)
            return basesections
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
