//
//  BaseMapOverlayTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 16.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class BaseMapOverlayTVC: UITableViewCell {
   
    public var overlay : BaseMapOverlay?
    @IBOutlet weak var imageContentView: UIView!
    
    public func set(overlay : BaseMapOverlay)
    {
        self.overlay = overlay
        if let newView = overlay.getImage()
        {
            //removing constraints
            //newView.removeConstraints(newView.constraints)
            //Setting constraints
            //newView.addConstraints(imageContentView.constraints)
            //Adding view to tableviewcell
            newView.backgroundColor = .clear
            
            print(self.contentView.subviews.count)
            for sub_view in self.imageContentView.subviews
            {
                self.imageContentView.willRemoveSubview(sub_view)
                sub_view.removeFromSuperview()
            }
            self.imageContentView.addSubview(newView)
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
