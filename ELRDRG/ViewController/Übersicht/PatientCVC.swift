//
//  PatientCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 08.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

public class PatientCVC: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    public var anzahl : Int = 12
    let handler = DataHandler()
    var victimList : [Victim] = []
    var alreadyLoaded : Bool = false
    public var delegate : presentViewController?
    
   public func setup()
   {
       self.layoutMargins.top = 20
       layoutMarginsDidChange()
       tableView.dataSource = self
       tableView.delegate = self
       tableView.reloadData()
    }
    
    

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        victimList = handler.getVictims()
        victimList.sort(by: {$0.id > $1.id})
        self.layoutMargins.top = 20
        self.clipsToBounds = false
        self.layoutMarginsDidChange()
        return victimList.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientOverViewTVC") as! PatientOverViewTVC
            cell.loadInfo()
            return cell
        }
        else
        {
              let cell = tableView.dequeueReusableCell(withIdentifier: "PatientUITVC") as! PatientUITVC
              cell.setPatient(Patient: victimList[indexPath.row - 1])
              cell.contentView.backgroundColor = UIColor.clear
              cell.backgroundLabel.layer.masksToBounds = true
              self.clipsToBounds = true
              
         cell.backgroundLabel.layer.cornerRadius = 5
         /* cell.backgroundLabel.layer.shadowOffset = CGSize(width: -1, height: -1)
          cell.backgroundLabel.layer.shadowOpacity = 1.0*/
              cell.delegate = self.delegate
                          
              return cell
        }
        
        
        
      
    }
    
    
    
    
    
}
