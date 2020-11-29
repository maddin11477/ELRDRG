//
//  NotificationsTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.10.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class NotificationsTVC: UITableViewCell {

    @IBOutlet weak var lbl_time: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var lbl_sender: UILabel!
    
    @IBOutlet weak var lbl_content: UILabel!
    
    @IBOutlet weak var acknowledge: UIButton!
    
    public var notification : Notification?
    
    public var delegate : NotificationDelegate?
    
    public func setupCell(notification : Notification)
    {
        self.notification = notification
        setIconImage()
        setButtonIcon()
        lbl_sender.text = notification.sender
        lbl_content.text = notification.content
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "dd.MM.yyyy"
        lbl_date.text = customFormatter.string(for: Date())
        customFormatter.dateFormat = "HH:mm"
        lbl_time.text = customFormatter.string(for: Date())
    }
    
    public func NotificationsTVC()
    {
        
    }
    
    
    @IBAction func cmd_acknowledge(_ sender: Any) {
        
        if !notification!.acknowledged
        {
            notification!.acknowledged = true
            setIconImage()
            setButtonIcon()
            if let not = notification
            {
                self.delegate?.NotificationChanged?(notification: not)
            }
            
        }
        
        
        DataHandler().saveData()
        
        
    }
    
    func setIconImage()
    {
        var iconName = "envelope.badge"
        if notification!.acknowledged
        {
            iconName = "envelope.open"
        }
        self.icon.image = UIImage(systemName: iconName)
        
        
    }
    
    func setButtonIcon()
    {
        var iconName = "checkmark.rectangle"
        if notification!.acknowledged
        {
            iconName = "checkmark.rectangle.fill"
            acknowledge.tintColor = UIColor.green
            
            acknowledge.isEnabled = false
        }
        else
        {
            acknowledge.isEnabled = true
            acknowledge.tintColor = UIColor.blue
        }
        
        self.acknowledge.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
