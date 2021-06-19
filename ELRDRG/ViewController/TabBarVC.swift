//
//  TabBarVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 28.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        return
        /*if let tabItems = self.tabBar.items {
            
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[4]
            let notificationsCounter = DataHandler().getNotifications().filter({return !$0.acknowledged}).count
            if notificationsCounter > 0
            {
                tabItem.badgeValue = String(notificationsCounter)
                tabItem.badgeColor = UIColor.red
            }
            else
            {
                tabItem.badgeValue = nil
            }
                
            
        }*/
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
