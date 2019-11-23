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
    
    public func UpdatedDocumentations()
    {
        data.saveData()
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
    }
    
    public func SaveAudioDocumentation(audioName: String, description: String, saveDate: Date){
        //get current mission
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let docuEntry = Documentation(context: AppDelegate.viewContext)
        let attachment = Attachment(context: docuEntry.managedObjectContext!)
        
        docuEntry.id = getLastDocuID() + 1
        docuEntry.content = description
        docuEntry.created = saveDate
        attachment.type = DocumentationType.Audio.rawValue
        attachment.uniqueName = audioName
        docuEntry.addToAttachments(attachment)
        
        mission.addToDocumentations(docuEntry)
        
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
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
        attachment.type = DocumentationType.Photo.rawValue
        attachment.uniqueName = uuidOfPhoto
        docuEntry.addToAttachments(attachment)
        
        mission.addToDocumentations(docuEntry)
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
    }
    
    public func updatePhotoDocumentation(docu : Documentation, text : String?, picture : UIImage)
    {
        let uuidOfPhoto = NSUUID().uuidString
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let _ = saveImageToDocumentDirectory(image: picture, uuid: uuidOfPhoto)
        let attachment = (docu.attachments?.allObjects as! [Attachment])[0]
        attachment.uniqueName = uuidOfPhoto
        //docu.content = text ?? docu.content
        if(text != nil)
        {
            docu.content = text!
        }
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
        
    }
    
    public func deleteDocuEntry(id: Int){
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        let result = mission.documentations?.allObjects as! [Documentation]
        for o in result{
            if o.id == id{
                mission.removeFromDocumentations(o)
                
                
                
                
                //TODO:Schauen wie man wirklich löscht... dateien auch löschen!!!
                
                
                
                
                
                
                
                
            }
        }
        data.saveData()
        DocumentationHandler.delegate?.updatedMDocumentationList(docuList: mission.documentations?.allObjects as! [Documentation])
    }
    
    
    //Bild lokal speichern
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    func saveImageToDocumentDirectory(image: UIImage, uuid: String)->URL{
        
        let storagePath = getDocumentsDirectory().appendingPathComponent(("\(uuid).jpg"))
        
        if let data = UIImageJPEGRepresentation(image, 0.5),
            !FileManager.default.fileExists(atPath: storagePath.path) {
            do {
                // writes the image data to disk
                try data.write(to: storagePath)
            } catch {
                print("error saving file:", error)
            }
        }
        
        return storagePath
    }
    
    //Foto wieder laden
    func getImage(pictureName: String) -> UIImage? {
        let picturePath = getDocumentsDirectory().appendingPathComponent(("\(pictureName).jpg"))
        if FileManager.default.fileExists(atPath: picturePath.path){
            let image = UIImage(contentsOfFile: picturePath.path)
            return image!
        } else {
            return nil
        }
    }
    
    func getImagePath(pictureName: String) -> String
    {
        let picturePath = getDocumentsDirectory().appendingPathComponent(("\(pictureName).jpg"))
        //let storagePath = getDocumentsDirectory().appendingPathComponent(("\(uuid).jpg"))
        return picturePath.path
    }
    
}
