//
//  LoginPopup.swift
//  ELRDRG
//
//  Created by Martin Mangold on 25.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class LoginPopupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var login = LoginHandler()
    var users = [User]()
    var selectableUsers = [String]()
    var tmpUsers = [String]()
    
    var delegate: LoginProtocol?

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var tblUserList: UITableView!
    
    @IBAction func login(_ sender: UIButton) {
        //soooo jetzt richtigen nutzer finden um an die unique id zu kommen
        let last = txtUsername.text!.components(separatedBy: ",")[0]
        if let currentUser = users.first(where: {$0.lastName == last}){
            if(currentUser.password == txtPassword.text){
                delegate?.loginUser(user: (currentUser))
                //login.loggInUser(unique: currentUser.unique!, password: txtPassword.text!)
                dismiss(animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUserList.delegate = self
        tblUserList.dataSource = self
        
        users = login.getAllUsers()
        for index in users.indices{
            selectableUsers.append("\(users[index].lastName!), \(users[index].firstName!)")
            print("\(users[index].lastName!), \(users[index].firstName!)")
        }
        tmpUsers = selectableUsers
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func txtUsernameChanged(_ sender: UITextField) {
        if(tblUserList.isHidden){
            tblUserList.isHidden = false
        }
        self.selectableUsers.removeAll()
        if(txtUsername.text?.count != 0){
            for user in tmpUsers {
                if let strUsernameForSearch = txtUsername.text{
                    let range = user.lowercased().range(of: strUsernameForSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil{
                        self.selectableUsers.append(user)
                    }
                }
            }
        }
        else{
            for index in users.indices{
                selectableUsers.append("\(users[index].lastName!), \(users[index].firstName!)")
            }
        }
        tblUserList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txtUsername.resignFirstResponder()
        return true
    }
    
    @objc func searchRecords(_ textField: UITextField){
        self.selectableUsers.removeAll()
        if(txtUsername.text?.count != 0){
            for user in tmpUsers {
                if let strUsernameForSearch = txtUsername.text{
                        let range = user.lowercased().range(of: strUsernameForSearch, options: .caseInsensitive, range: nil, locale: nil)
                        if range != nil{
                            self.selectableUsers.append(user)
                        }
                    }
                }
        }
        else{
            for index in users.indices{
                selectableUsers.append("\(users[index].lastName!), \(users[index].firstName!)")
            }
        }
        tblUserList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectableUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "user")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "user")
        }
        cell?.textLabel?.text = selectableUsers[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtUsername.text = selectableUsers[indexPath.row]
        tblUserList.isHidden = true
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
