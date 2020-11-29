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

protocol UnitSectionDelegate {
    func handeledPatientDragDropAction()
    
}
class SectionHandler: NSObject {
    
    public var delegate : SectionProtocol?
    public static var SectionUnitDelegate : UnitSectionDelegate?
    let login = LoginHandler()
    
    public func deleteBaseSection(basesection : BaseSection)
    {
        AppDelegate.viewContext.delete(basesection)
        saveData()
    }
  
    
	public static func getTableItemsCount(section : Section) -> ([Unit], [UnitPattern])
	{
		var newUnits : [Unit] = []
		var newUnitPatterns : [UnitPattern] = []
		var newVictims : [Victim] = []
		//Units
		let units : [Unit] = (section.units?.allObjects as? [Unit]) ?? []
		for unit in units {

			//each unit has to be investigated
			if let victims = unit.getVictims()
			{
				//Only one victim allowed and is allowed to be added only once
				if victims.count == 1 && newVictims.contains(victims[0]) == false
				{

					if let pattern = UnitPattern.generatePattern(newVictim: victims[0])
					{
						newUnitPatterns.append(pattern)
						newVictims.append(victims[0])
					}
					else
					{
						newUnits.append(unit)
					}
				}
				else
				{
					if victims.count > 0 && newVictims.contains(victims[0]) == false
					{
						newUnits.append(unit)
					}

				}

			}
		}


		return (newUnits, newUnitPatterns)
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
    
    public func deleteSection(sec : Section)
    {
        if let annotation = sec.mapAnnotation
        {
            SectionMapAnnotation.delete(annotation: annotation)
        }
        AppDelegate.viewContext.delete(sec)
        
        saveData()
        
        
    }
    
    public func getSections() -> [Section]
    {
        let mission : Mission = getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
         var array =  mission.sections?.allObjects as! [Section]
        array.sort(by: { $0.id < $1.id})
        
        return array
    }
    
    func addDefaultSections(mission : Mission)
    {
        if SettingsHandler().getSettings().add_standard_sections_automatically
        {
           let sections = getAllSections()
           var defaultSections : [BaseSection] = []
           for sec in sections {
               if sec.allwaysExits
               {
                   defaultSections.append(sec)
               }
           }
           
           defaultSections.sort{ $1.counter > $0.counter }
           for sec in defaultSections {
               self.createDefaultSection(identifier: sec.identifier ?? "", mission: mission)
           }
           saveData()
        }
       
        
    }
    
    private func createDefaultSection(identifier : String, mission : Mission)
    {
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
