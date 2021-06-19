//
//  StammdatenServer.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 27.04.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class StammdatenServerViewController: UIViewController {
    
    @IBOutlet weak var txtUrl: UITextField!
    
    @IBOutlet weak var cmdTestConnection: RoundButton!
    
    @IBOutlet weak var inProgressIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imgCheckmark: UIImageView!
    
    @IBOutlet weak var enableServerSwitch: UISwitch!
    
    @IBOutlet weak var lblLog: UILabel!
    
    @IBAction func testConnection(_ sender: Any) {
        
    }
    
    func enableUIControls(state : Bool)
    {
        self.inProgressIndicator.isHidden = true
        self.inProgressIndicator.stopAnimating()
        self.view.subviews.forEach({
            (element) in
            //disable all controls
            if let uiObject = element as? UIControl
            {
                uiObject.isEnabled = state
            }
            
            if let uiButton = element as? UIButton
            {
                uiButton.backgroundColor = state ? UIColor.init(named: "UIButtonBackcolor") : UIColor.lightGray
            }
            
        })
    }
    
    @IBAction func enableServerSwitched(_ sender: Any) {
        enableUIControls(state: self.enableServerSwitch.isOn)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //Save new Setting -> replace current dataset for server entitie in mission.setting
        let data = SettingsHandler().getSettings()
        if self.enableServerSwitch.isOn
        {
            let server : Server = Server()
            //server.serverActive = true
            server.url = txtUrl.text
            data.server = server
        }
        else
        {
            data.server = nil
        }
        let _ = SettingsHandler().save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load startcondition
        let data = SettingsHandler().getSettings()
        var slog = ""
        if let server = data.server
        {
            enableServerSwitch.isOn = server.serverActive
            txtUrl.text = server.url
            server.logs?.forEach({
                (entrie) in
                let log = entrie as! Log
                slog += log.date!.ToLongDateString() + " " + log.date!.ToShortTimeString() + "\n"
            })
        }
        lblLog.text = slog
        
        enableServerSwitched(enableServerSwitch)
    }
}
