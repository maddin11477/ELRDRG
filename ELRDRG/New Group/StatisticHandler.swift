//
//  StatisticHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation


public class StatisticHandler
{
    public enum MissionType : String, CaseIterable{
        case none = "Einsatzart auswählen"
        case Brand = "Brand"
        case BMA = "BMA"
        case VU = "VU"
        case Gefahrgut = "Gefahrgut"
        case PolSituation = "Polizei Sonderlage"
        case Vermisstensuche = "Vermisstensuche"
        case MassenErkrankte = "Mehrfach erkrankt"
        case Sonstiges = "Sonstiges"
    }
    
    func getAmountByType(missionType:MissionType)
    {
        var missions = DataHandler().getAllMissions(missions: true) // Alle Missions laden
        missions = missions.filter({mission in
            return mission.missionType == missionType.rawValue
        })
    }
}
