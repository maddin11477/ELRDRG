//
//  UebersichtVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 28.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class UebersichtVC: UIViewController {
    let login : LoginHandler = LoginHandler()
    let data : DataHandler = DataHandler()
    @IBAction func endMission_Click(_ sender: Any)
    {
        data.setEndDate()
        login.setCurrentMissionUnique(unique: nil)
        self.dismiss(animated: true, completion: nil)
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
