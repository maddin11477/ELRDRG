//
//  MissionCommanderCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 13.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class MissionCommanderCVC: iMissionMetaDataCVC, UITableViewDelegate, UITableViewDataSource,CommanderTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Einsatzleiter:"
        default:
            return "Mögliche Einsatzleiter"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    var userList : [User] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            self.userList = LoginHandler().getAllUsers()
            return self.userList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mission == nil
        {
            fatalError("mission found nil")
        }
        
        switch indexPath.section {
        
        case 0:
            //Selected Commander List
            for user in self.userList {
                if self.mission?.user == user
                {
                    let cell = self.commanderTableView.dequeueReusableCell(withIdentifier: "CommanderTableViewCell2") as! CommanderTableViewCell
                    cell.set(commander: user, mission: self.mission!)
                    cell.delegate = self
                    return cell
                }
            }
            
            break;
            
        case 1:
            //Commander List
            let cell = self.commanderTableView.dequeueReusableCell(withIdentifier: "CommanderTableViewCell2") as! CommanderTableViewCell
           
            cell.set(commander: self.userList[indexPath.row], mission: self.mission!)
            cell.delegate = self
            return cell
            
        default:
            break;
        }
        return UITableViewCell()
    }
    
    
    
    override func load(object: AnyObject? = nil) {
        super.load(object: object)
        self.commanderTableView.delegate = self
        self.commanderTableView.dataSource = self
        self.commanderTableView.reloadData()
        
    }
    
    override func save(object: AnyObject? = nil) {
        //TODO:
    }
    
    
    public override func getCellIdentifier()->String {
        return "MissionCommanderCVC"
    }
    
    @IBOutlet weak var commanderTableView: UITableView!
    
    
    func didSelectCommander(commander: User) {
        //changed mission Commander
        // TODO: event when new commander is selected
        
        if let mission = self.mission
        {
            mission.user = commander
            self.commanderTableView.reloadData()
        }
        
    }
    
}
