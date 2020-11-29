//
//  NotificationsViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.10.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationDelegate {
    
    func NotificationChanged(notification: Notification) {
        tableView.reloadData()
    }
    
    func refreshNotifications(notifications: [Notification]) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notifications = dataHandler.getNotifications()
        let unreadMessagesCounter = self.notifications.filter({return !$0.acknowledged}).count
        setBadge(counter: unreadMessagesCounter)
        return notifications.count
    }
    
    func setBadge(counter : Int)
    {
        if let tabItems = tabBarController?.tabBar.items {
            
            let tabItem = tabItems[4]
            if counter > 0
            {
                tabItem.badgeValue = String(counter)
                tabItem.badgeColor = UIColor.red
            }
            else
            {
                tabItem.badgeValue = nil
            }
           
        }
    }
    
    
    @IBAction func removeAll(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "LÖSCHEN", message: "Sind Sie sicher, dass Sie alle Nachrichten löschen möchten?", preferredStyle: .actionSheet)
        let abort = UIAlertAction(title: "Abbrechen", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Löschen", style: .destructive,
                                   handler: {(alert : UIAlertAction) in self.dataHandler.deleteNotifications()
                                    self.tableView.reloadData()
        })
        alertcontroller.addAction(abort)
        alertcontroller.addAction(delete)
        alertcontroller.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        
        self.present(alertcontroller, animated: true, completion: ({ self.tableView.reloadData()}))
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationsTVC
        cell.setupCell(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    let dataHandler = DataHandler()
    var notifications : [Notification] = []
    
    override func viewWillAppear(_ animated: Bool) {
        //dataHandler.createNotification(sender: "ELRD APP", content: "Test Content")
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "", handler: {(action, view, completetionHandler) in
            self.dataHandler.deleteNotifications(index: indexPath.row)
            self.dataHandler.saveData()
            self.tableView.reloadData()
            completetionHandler(true)
        })
        
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = UIColor.red
        let configruation = UISwipeActionsConfiguration(actions: [action])
        return configruation
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    ->   UISwipeActionsConfiguration? {
        
        
        //SHARE
        let action_acknowleged =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            self.notifications[indexPath.row].acknowledged = !self.notifications[indexPath.row].acknowledged
            self.dataHandler.saveData()
            self.tableView.reloadData()
            completionHandler(true)
        })
        if notifications[indexPath.row].acknowledged
        {
            action_acknowleged.image = UIImage(systemName: "envelope.badge.fill")
            action_acknowleged.title = ""
        }
        else
        {
            action_acknowleged.image = UIImage(systemName: "envelope.open.fill")
            action_acknowleged.title = ""
        }
    
        action_acknowleged.backgroundColor = .blue
        let configuration = UISwipeActionsConfiguration(actions: [action_acknowleged])
        return configuration
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.dataHandler.notificationDelegate = self
        self.tableView.reloadData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var tableView: UITableView!
    
    
}

