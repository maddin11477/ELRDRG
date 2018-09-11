//
//  DocumentationHandler.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public enum DocumentationType: Int16{
    case Audio = 1
    case Photo = 2
    case Video = 3
}

public class DocumentationHandler {

    var login: LoginHandler = LoginHandler()
    var data: DataHandler = DataHandler()
    
    static var delegate : DocumentationProtocol?
    
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
    
    //Dateien in der Datenbank speichern
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
    
    public func SavePhotoDocumentation(picture: UIImage, description: String, saveDate: Date){
        let uuidOfPhoto = NSUUID().uuidString
        let storagePath = saveImageToDocumentDirectory(image: picture, uuid: uuidOfPhoto)
        
        //get current mission
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let docuEntry = Documentation(context: AppDelegate.viewContext)
        let attachment = Attachment(context: docuEntry.managedObjectContext!)
        
        docuEntry.id = getLastDocuID() + 1
        docuEntry.content = description
        docuEntry.created = saveDate
        attachment.storagePath = storagePath
        attachment.type = DocumentationType.Photo.rawValue
        attachment.uniqueName = uuidOfPhoto
        docuEntry.addToAttachments(attachment)
        
        mission.addToDocumentations(docuEntry)
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
        print("Dokueintrag \(description) erfolgreich gespeichert: \(saveDate)")
    }
    
    //Bild lokal speichern
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    func saveImageToDocumentDirectory(image: UIImage, uuid: String)->URL{
        
        let path = getDocumentsDirectory().appendingPathComponent(("\(uuid).jpg"))
        print("Saving foto to: \(path)")
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        FileManager.default.createFile(atPath: path.absoluteString, contents: imageData, attributes: nil)
        return path
    }
}
