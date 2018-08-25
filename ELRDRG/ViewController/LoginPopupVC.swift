//
//  LoginPopup.swift
//  ELRDRG
//
//  Created by Martin Mangold on 25.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class LoginPopupVC: UIViewController {
    var login = LoginHandler()
    var users = [User]()

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        login.loggInUser(username: username.text!, password: password.text!)
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        users = login.getAllUsers()
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
