//
//  MissionGeneralInfoCollectionViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class MissionGeneralInfoCollectionViewCell: iMissionMetaDataCVC {
    
    public override func getCellIdentifier() -> String {
        return "MissionGeneralInfoCollectionViewCell"
    }
    
    override func save(object: AnyObject? = nil) {
        super.save(object: object)
        if let einsatz = self.mission
        {
            einsatz.reason = txtmissionName.text
            einsatz.location = txtcity.text
            einsatz.missionTaskNumber = Int32(txtMissionNumber.text ?? "") ?? -1
            einsatz.startKm = txtKMStart.text
            einsatz.endKm = txtKMEnd.text
        }
    }
    
    override func load(object: AnyObject? = nil) {
        super.load(object: object)
        if let einsatz = self.mission
        {
            txtMissionNumber.text = String(einsatz.missionTaskNumber)
            txtmissionName.text = einsatz.reason
            txtcity.text = einsatz.location
            txtKMStart.text = einsatz.startKm
            txtKMEnd.text = einsatz.endKm
        }
    }
    
    
    
    @IBOutlet weak var txtmissionName: UITextField!
    
    @IBOutlet weak var txtcity: UITextField!
    
    @IBOutlet weak var txtMissionNumber: UITextField!
    
    @IBOutlet weak var txtKMStart: UITextField!
    
    @IBOutlet weak var txtKMEnd: UITextField!
    
    
    
    
}
