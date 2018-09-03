//
//  DocumentationHandler.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import Foundation
import CoreData

public enum DocumentationType: Int16{
    case Audio = 1
    case Photo = 2
    case Video = 3
}

public class DocumentationHandler {

    var login: LoginHandler = LoginHandler()
    var data: DataHandler = DataHandler()
    
    static var delegate : DocumentationProtocol?
    
    public func SaveTextDocumentation(textcontent: String, savedate : Date){
        //get current mission
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let docuEntry = Documentation(context: AppDelegate.viewContext)
        docuEntry.id = getLastDocuID() + 1
        
        docuEntry.created = savedate
        docuEntry.content = textcontent
        mission.addToDocumentations(docuEntry)
        
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
        print("Dokueintrag \(textcontent) erfolgreich gespeichert: \(savedate)")
    }
    
    public func getAllDocumentations() -> [Documentation]{
        
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        var result = mission.documentations?.allObjects as! [Documentation]
        result.sort(by: { $0.id > $1.id})
        print("\(result.count) Einträge gefunden...")
        if result.count > 0{
            return result
        }else{
            return []
        }
    }
    
    private func getLastDocuID() -> Int16 {
        //TODO: Hier muss noch gefiltert werden, damit auch eine ID pro Lage generiert wird...
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let request: NSFetchRequest<Documentation> = Documentation.fetchRequest()
        request.predicate = NSPredicate(format: "mission == %@", mission)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        do
        {
            let entries = try AppDelegate.viewContext.fetch(request)
            
            if(entries.count < 1)
            {
                
                return 0
            }
            print("ID \(entries[0].id)")
            return entries[0].id
            
        }
        catch
        {
            print(error)
        }
        return 0
    }
    
}
