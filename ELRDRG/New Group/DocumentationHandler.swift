//
//  DocumentationHandler.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import Foundation
import CoreData

public struct DocumentationHandler {

    var login: LoginHandler = LoginHandler()
    var data: DataHandler = DataHandler()
    
    public func SaveTextDocumentation(textcontent: String, savedate: Date){
        //get current mission
        let mission = data.getMissionFromUnique(unique: (login.getLoggedInUser()!.currentMissionUnique!))!
        
        let docuEntry = Documentation(context: AppDelegate.viewContext)
        docuEntry.textDocumentation?.content = textcontent
        docuEntry.created = savedate
        
        mission.addToDocumentations(docuEntry)
        
        data.saveData()
        print("Dokueintrag \(textcontent) erfolgreich gespeichert: \(savedate)")
    }
    
}
