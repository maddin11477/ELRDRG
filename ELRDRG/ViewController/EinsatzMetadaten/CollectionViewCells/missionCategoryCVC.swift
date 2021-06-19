//
//  missionCategoryCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 16.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class missionCategoryCVC: iMissionMetaDataCVC, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    public override func getCellIdentifier() -> String {
        return "missionCategoryCVC"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StatisticHandler.MissionType.allCases[row].rawValue
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StatisticHandler.MissionType.allCases.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let mission = self.mission
        {
            mission.missionType = StatisticHandler.MissionType.allCases[row].rawValue
        }
    }
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override public func load(object: AnyObject? = nil) {
        super.load(object: object)
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        if let mission = object as? Mission
        {
            self.mission = mission
        }
        loadPickerView()
    }
    
    override public func save(object: AnyObject? = nil) {
        DataHandler().saveData()
    }
 
    func loadPickerView()
    {
        if let einsatz = self.mission
        {
            //self.missionTypePickerView.reloadAllComponents()
            let missionType = StatisticHandler.MissionType.init(rawValue: einsatz.missionType ?? StatisticHandler.MissionType.allCases[0].rawValue)
            var row = -1
            if let type = missionType
            {
                row = StatisticHandler.MissionType.allCases.index(of: type) ?? 0
            }
            else
            {
                row = 0
            }
            
            self.categoryPicker.selectRow(row, inComponent: 0, animated: false)
        }
        
    }
    
    
}
