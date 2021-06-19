//
//  MissionDateCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 17.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class MissionDateCVC: iMissionMetaDataCVC {
    public override func getCellIdentifier() -> String {
        return "MissionDateCVC"
    }
    
    
    
    @IBOutlet weak var lblStartDateTime: UILabel!
    
    @IBOutlet weak var lblEndDateTime: UILabel!
    
    
    @IBAction func StartDateDidChange(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        if let mission = self.mission
        {
            mission.start = StartDateTimePicker.date
            lblStartDateTime.text = formatter.string(from: StartDateTimePicker.date) + " Uhr"
        }
        
        
    }
    
    @IBAction func EndDateDidChange(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        if let mission = self.mission
        {
            mission.end = EndDateTimePicker.date
            lblEndDateTime.text = formatter.string(from: EndDateTimePicker.date) + " Uhr"
        }
        

       
    }
    
    
    @IBOutlet weak var StartDateTimePicker: UIDatePicker!
    
    @IBOutlet weak var EndDateTimePicker: UIDatePicker!
    
    
     override func load(object: AnyObject? = nil) {
        super.load(object: object)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        if let mission = self.mission
        {
            if let date = mission.start
            {
                self.lblStartDateTime.text = formatter.string(from: date) + " Uhr"
                self.StartDateTimePicker.setDate(date, animated: true)
            }
            else
            {
                self.lblStartDateTime.text = ""
            }
            if let date = mission.end
            {
                self.lblEndDateTime.text = formatter.string(from: date) + " Uhr"
                self.EndDateTimePicker.setDate(date, animated: true)
            }
            else
            {
                self.lblEndDateTime.text = ""
            }
        }
        

    }
    
     override func save(object: AnyObject? = nil) {
        super.save()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        if let mission = self.mission
        {
            mission.end = EndDateTimePicker.date
            lblEndDateTime.text = formatter.string(from: EndDateTimePicker.date) + " Uhr"
        }
        
        
        
        if let mission = self.mission
        {
            mission.start = StartDateTimePicker.date
            lblStartDateTime.text = formatter.string(from: StartDateTimePicker.date) + " Uhr"
        }
        
    }
    
    
}
