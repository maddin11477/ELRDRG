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
            car.crewCount = 2
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
        for _car in RTHs {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 5
        }
        
        //RTH erstellen
        for _car in Kdows {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 6
        }
        
        //RTH erstellen
        for _car in MTW {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 7
        }
        
        //RTH erstellen
        for _car in LKW {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 8
        }
        
        //RTH erstellen
        for _car in KTWKATS {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 9
        }
        
        for _car in wasserwacht {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 10
        }
        
        for _car in elw {
            let car = BaseUnit(context: AppDelegate.viewContext)
            car.funkrufName = _car
            car.crewCount = 2
            car.type = 11
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
