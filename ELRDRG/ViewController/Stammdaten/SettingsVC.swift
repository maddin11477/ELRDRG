//
//  SettingsVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    let sections = ["Stammdaten", "Administration", "Syncoptions"]
    let settings_sec1 = ["Fahrzeuge", "Kliniken", "Diagnosen", "Abschnitte"]
    
    @IBOutlet var table: UITableView!
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if(indexPath.section == 0)
        {
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "StammdatenDetailVC") as! StammdatenDetailVC
            if(indexPath.row == 0)
            {
                vc.type = .Fahrzeuge
            }
            else if(indexPath.row == 1)
            {
                vc.type = .Kliniken
            }
            else if(indexPath.row == 2)
            {
                vc.type = .Diagnosen
            }
            else if(indexPath.row == 3)
            {
                vc.type = .Abschnitte
            }
            self.navigationController?.pushViewController(vc, animated: true)
           // self.present(vc, animated: true, completion: nil)
            
        }
        else if(indexPath.section == 2 && indexPath.row == 0)
        {
            //Server Stammdaten Einstellungen
            let vc = self.storyboard?.instantiateViewController(identifier: "StammdatenServerViewController") as! StammdatenServerViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
