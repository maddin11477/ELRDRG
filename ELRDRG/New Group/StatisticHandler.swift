//
//  StatisticHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import Foundation

public struct MissionTypeResult
{
    var missionType : StatisticHandler.MissionType
    var amount : Int
}

public struct MissionStatisticResult
{
    var missionTypeStatistic : [MissionTypeResult]
    var user : User? // User == nil allgemein über alle Benutzer
}



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
        case Bergrettungseinsatz = "Bergrettungseinsatz"
        case Wasserrettungseinsatz = "Wasserrettungseinsatz"
        case MassenErkrankte = "Mehrfach erkrankt"
        case Sonstiges = "Sonstiges"
    }
    /*
     * user == nil wenn eine globale
     * Statistic erstellt werden soll,
     * unabhängig eines Benutzers
     */
    public func createStatistic(user : User?)->MissionStatisticResult
    {
        var results : [MissionTypeResult] = []
        for type in StatisticHandler.MissionType.allCases {
            results.append(MissionTypeResult(missionType: type, amount: getAmountByType(missionType: type, from: user)))
        }
        return MissionStatisticResult(missionTypeStatistic: results, user: user)
    }
    
    func getAmountByType(missionType:MissionType,from user : User? = nil)->Int
    {
        var missions = DataHandler().getAllMissions(missions: true) // Alle Missions laden
        missions = missions.filter({mission in
            if let u = user
            {
                return (mission.missionType == missionType.rawValue) && (mission.user == u)
            }
            else
            {
                return mission.missionType == missionType.rawValue
            }
            
        })
        return missions.count
    }
    
    
}
