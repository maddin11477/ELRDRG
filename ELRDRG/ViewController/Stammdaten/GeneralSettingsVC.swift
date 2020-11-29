//
//  GeneralSettingsVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 29.02.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class GeneralSettingsVC: UITableViewController {

    @IBOutlet weak var txt_commandRegion: UITextField!
    
	@IBOutlet var generate_sections_automatically_switch: UISwitch!

	@IBOutlet var add_newSections_toMission_switch: UISwitch!

	@IBOutlet var safe_new_sections_permanent_switch: UISwitch!

	@IBOutlet var show_all_users_switch: UISwitch!

    @IBOutlet weak var txt_ILSMailAdresse: UITextField!
    
    override func viewWillDisappear(_ animated: Bool) {
        if let setting = self.einstellungen
        {
            setting.ils_mailAdress = txt_ILSMailAdresse.text
            setting.commanderRegion = txt_commandRegion.text
            let _ = SettingsHandler().save()
        }
    }
    

	var einstellungen : Settings?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.einstellungen = SettingsHandler().getSettings()
		if let setting = einstellungen
		{

			self.generate_sections_automatically_switch.isOn = setting.add_standard_sections_automatically
			self.add_newSections_toMission_switch.isOn = setting.add_new_sections_to_mission
			self.safe_new_sections_permanent_switch.isOn = setting.safe_new_sections_permanent
			self.show_all_users_switch.isOn = setting.showAllMissions
            self.txt_ILSMailAdresse.text = setting.ils_mailAdress
            self.txt_commandRegion.text = setting.commanderRegion
		}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	@IBAction func generate_sections_automatically_switched(_ sender: Any) {
		if let setting = einstellungen
		{
			setting.add_standard_sections_automatically = self.generate_sections_automatically_switch.isOn
			let _ = SettingsHandler().save()
		}
	}

	@IBAction func showAllMissions_changed(_ sender: Any) {
		if let setting = einstellungen
		{

			setting.showAllMissions = self.show_all_users_switch.isOn
			let _ = SettingsHandler().save()
		}
	}


	@IBAction func Add_newSections_toMission_changed(_ sender: Any) {
		if let setting = einstellungen
		{

			setting.add_new_sections_to_mission = self.add_newSections_toMission_switch.isOn
			let _ = SettingsHandler().save()
		}
	}

	@IBAction func safe_new_sections_permanent_changed(_ sender: Any) {
		if let setting = einstellungen
		{

			setting.safe_new_sections_permanent = self.safe_new_sections_permanent_switch.isOn
			let _ = SettingsHandler().save()
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
