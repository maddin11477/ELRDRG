//
//  SessionHandler.swift
//  ELRDRG
//
//  Created by Martin Mangold on 03.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//
//Hier nur zugriff aus UserDefaults um die Anmeldungen zu tracken und zu handeln

//TODO: Umbau der anderen Handler um hierauf zuzugreifen


import Foundation

class SessionHandler: NSObject {
    
    //Fragt ab ob die App schonmal gestartet wurde oder ob es der erste Start ist
    //false = App startet zum ersten mal
    //true = App wurde bereits gestartet
    public func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            //print("App already launched") //Debug
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //print("App launched first time") //Debug
            return false
        }
    }
    
    //Meldet den ausgewählten Nutzer an, UUID des Benutzers wird gespeichert
    public func loggInUser(userUUID: String){
        let defaults = UserDefaults.standard
        defaults.set(userUUID, forKey: "loggedInUser")
        //print("user logged in: \(String(describing: userUUID))") //Debug
    }
    
    //Meldet den aktuellen Nutzer ab, beim Neustart der App ist eine Anmeldung erforderlich
    public func loggOffUser(){
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "loggedInUser")
    }
    
    //Fragt den aktuellen Nutzer ab und gibt die UUID des Nutzers zuück
    //Gibt "nil" zurück wenn kein Nutzer angemeldet ist
    public func getLoggedInUser() -> String? {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "loggedInUser"){
            return uuid
        }else{
            //print("Nobody logged in") //Debug
            return nil
        }
    }
    
}

