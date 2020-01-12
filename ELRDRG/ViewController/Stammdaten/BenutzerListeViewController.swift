//
//  BenutzerListeViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 08.10.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class BenutzerListeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddUserDelegate{
    func addedUser() {
        userList = loginHander!.getAllUsers()
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var loginHander : LoginHandler?
    var userList : [User] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BenutzerTableViewCell") as! BenutzerTableViewCell
        cell.txt_Name.text = userList[indexPath.row].firstName! + " " + userList[indexPath.row].lastName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowUserViewController") as! ShowUserViewController
        viewController.user = userList[indexPath.row]
        viewController.delegete = self
        viewController.modalPresentationStyle = .formSheet
        viewController.popoverPresentationController?.sourceView = self.view
        self.present(viewController, animated: true, completion: nil)
    }
    

    @IBAction func AddUser(_ sender: Any)
    {
        let addUserController = self.storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        addUserController.delegate = self
        addUserController.modalPresentationStyle = .formSheet
        addUserController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        //addUserController.popoverPresentationController?.sourceView = self.view
        
        self.present(addUserController, animated: true, completion: nil)
      
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginHander = LoginHandler()
        userList = loginHander!.getAllUsers()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
