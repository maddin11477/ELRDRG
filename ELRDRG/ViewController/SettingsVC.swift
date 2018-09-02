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
    let settings_sec1 = ["Fahrzeuge", "Kliniken", "Diagnosen"]
    
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
            self.present(vc, animated: true, completion: nil)
            
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
