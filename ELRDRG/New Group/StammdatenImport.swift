//
//  StammdatenImport.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 25.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class StammdatenImport: UITableViewCell {

    
    let RTWs = ["RK BISHM 71/1", "RK BISHM 71/70", "RK BKOHN 71/1", "RK BKOHN 71/70", "RK BNEST 71/1", "RK BNEST 71/2", "RK BNEST 71/3", "RK BNEST 71/70", "RK LALEI 71/1", "RK MELST 71/70", "RK NHM 71/1"]
    let KTWs = ["RK BNEST 72/1", "RK BNEST 72/2", "RK BKOHN 72/70", "JO MELST 72/1", "JO MELST 72/2", "JO MELST 72/3"]
    let NEFs = ["RK BISHM 76/1", "RK BKOHN 76/1", "RK BNEST 76/1", "RK MELST 76/1"]
    let RTHs = ["Christoph 18", "Christoph 28", "Christoph 60", "Christoph 2", "Christoph 20", "Christoph Nürnberg", "Christoph Thüringen", "Christoph Mittelhessen", "Christoph Gießen"]
    let Krad = ["RK NES 17/1", "RK NES 17/2"]
    let Kdows = ["RK BNEST 10/1", "RK BNEST 10/2", "RK BNEST 10/3"]
    let sonstiges = ["RK BNEST 74/1", "RK BNEST 59/1"] //Landrettungsfahrzeug sonstiges
    let MTW = ["RK BISHM 14/1", "RK BNEST 11/2", "RK BNEST 14/1", "RK BNEST 14/10"]
    let LKW = ["RK BNEST 54/1", "RK BISHM 56/1"]
    let KTWKATS = ["RK BNEST 73/1", "RK MELST 73/10"]
    let wasserwacht = ["WW BNEST 91/1", "WW WÜHSN 94/1"]
    let elw = ["KAT NES 13/2"]
    
    
    
    
    func generateUnitObjects()
    {
        //RTWs erstellen
        for _car in RTWs {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 0
        }
        
        //KTWs erstellen
        for _car in KTWs {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 1
        }
        
        //NEF erstellen
        for _car in NEFs {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 1
            car.type = 2
        }
        
        //RTH erstellen
        for _car in RTHs {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 3
            car.type = 3
        }
        
        //Sonstiges erstellen
        for _car in sonstiges {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 4
        }
        
        //Krad erstellen
        for _car in Krad {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 1
            car.type = 5
        }
        
        //Kdows erstellen
        for _car in Kdows {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 6
        }
        
        //MTW erstellen
        for _car in MTW {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 9
            car.type = 7
        }
        
        //LKW erstellen
        for _car in LKW {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 8
        }
        
        //KTW erstellen
        for _car in KTWKATS {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 9
        }
        
        
        for _car in wasserwacht {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 9
            car.type = 10
        }
        
        for _car in elw {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 4
            car.type = 11
        }
        
        saveData()
        
        
    }
    
   
    let armArray = ["Oberarm#", "Oberarm# offen", "Oberarm Amputation", "Schulterluxation", "Ellenbogenluxation"]
    let oberschenkel = ["Oberschenkel#", "Oberschenkel# offen", "Oberschenkel Amputation", "Becken#", "Becken# offen"]
    let Unterschenkel = ["Unterschenkel#" + "Unterschenkel# offen", "Unterschenkel Amputation", "Patella#", "Patellaluxation", "OSG#", "OSG# offen", "Fuß Amputation"]
    let hand = ["Handgelenk#", "Handgelenk# offen", "Hand#", "Hand# offen", "Hand Amputation"]
    let abdomen = ["stumpfes Abdominaltrauma", "Abdominaltrauma offen", "penetrierendes Abdominaltrauma", "Abwehrspannung Abdomen", "Prellmarke Abdomen"]
    let thorax = ["stumpfes Thoraxtrauma", "penetrierendes Thoraxtrauma", "Thoraxtrauma offen", "Sternumprellung", "Sternum#", "Rippen#", "Rippenserien#", "Pneumothorax", "Spannungspneumothorax", "Spannungspneumothorax entlastet", "Hämatothorax"]
    let kopf = ["Comotio", "SHT I", "SHT I offen", "SHT II", "SHT II offen", "SHT III", "SHT III offen", "Mittelgesichts#", "wach ansprechbar", "Bewusstlos", "spontanatmend", "intubiert beatmet"]
    let wirbelsäule = ["HWS Distorsion", "HWS Trauma", "HWS Trauma mit Sensibilitätsstörungen", "BWS Trauma", "BWS Trauma mit Sensibilitätsstörungen", "LWS Trauma", "LWS Trauma mit Sensibilitätsstörungen", "Querschnittsymptomatik"]
    
    
    func createDiagnoses()
    {
        for value in armArray {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 0
            diag.diagnosis = value
            diag.loaction = "Arm"
        }
        
        for value in oberschenkel
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 1
            diag.diagnosis = value
            diag.loaction = "Oberschenkel"
        }
        
        for value in Unterschenkel
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 2
            diag.diagnosis = value
            diag.loaction = "Unterschenkel"
        }
        
        for value in hand
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 3
            diag.diagnosis = value
            diag.loaction = "Hand"
        }
        
        for value in abdomen
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 4
            diag.diagnosis = value
            diag.loaction = "Abdomen"
        }
        
        for value in thorax
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 5
            diag.diagnosis = value
            diag.loaction = "Thorax"
        }
        
        for value in kopf
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 6
            diag.diagnosis = value
            diag.loaction = "Kopf"
        }
        
        for value in wirbelsäule
        {
            let diag = BaseInjury(context: AppDelegate.viewContext)
            diag.category = 7
            diag.diagnosis = value
            diag.loaction = "Wirbelsäule"
        }
        
        saveData()
        
    }
    
    
    public func generateHospitals()
    {
        var i : Int = 0
        for value in hospitalname
        {
            let hos = BaseHospital(context: AppDelegate.viewContext)
            hos.city = KLinikOrt[i]
            hos.lat = lat[i]
            hos.lng = lng[i]
            hos.name = value
            i = i + 1
        }
        saveData()
    }
    
    let hospitalname = ["Campus Rhön", "St. Elisabeth", "Klinikum Meiningen", "Leopoldina", "St. Josef", "Franz von Prümmer Klinik", "KHS Hammelburg", "KHS Hassfurt", "KHS Ebern", "Klinikum Fulda", "Klinikum Suhl", "Uni Würzburg", "Zentralklinik Bad Berka", "Klinikum Coburg", "BGU Klinik"]
    let KLinikOrt = ["Bad Neustadt", "Bad Kissingen", "Meiningen", "Schweinfurt", "Schweinfurt", "Bad Brückenau", "Hammelburg", "Hassfurt", "Ebern", "Fulda", "Suhl", "Würzburg", "Bad Berka", "Coburg", "Frankfurt"]
    let lng = [50.323636, 50.189797, 50.557849, 50.051994, 50.051994, 50.307681, 50.119965, 50.040304, 50.097157, 50.548481, 50.60252, 49.806359, 50.889507, 50.246963, 50.144988]
    let lat = [10.23298, 10.083099, 10.397545, 10.24366, 10.24366, 9.785157, 9.898004, 10.514484, 10.798534, 9.706519, 10.70957, 9.95758, 11.266051, 10.973357, 8.709632]
    
    
    
    private func saveData()
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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
