//
//  UnitCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 10.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class UnitCVC: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var lbl_Funkrufname: UILabel!
    
    @IBOutlet var img_Victim_set: UIImageView!
    
    @IBOutlet var img_Hospital_set: UIImageView!
    
    @IBOutlet var lbl_section: UILabel!
    
    
    public func setup(unit : Unit)
    {
        self.image.image = UIImage(named: UnitHandler().BaseUnit_To_UnitTypeString(id: unit.type))
        lbl_Funkrufname.text = unit.callsign ?? ""
        lbl_section.text = unit.section?.identifier ?? ""
        var category : Int = 10
        
        for vic in unit.patient?.allObjects as! [Victim]
        {
            if(vic.category < category)
            {
                category = Int(vic.category)
                var color : UIColor = .lightGray
                switch vic.category {
                case 1:
                    color = .red
                case 2:
                    color = .orange
                case 3:
                    color = .green
                case 4:
                    color = .lightGray
                case 5:
                    color = .blue
                default:
                    color = .clear
                }
                self.image.backgroundColor = color
                if let _ = vic.hospital
                {
                    img_Hospital_set.tintColor = .red
                }
                else
                {
                    img_Hospital_set.tintColor = .lightGray
                }
            }
        }
        if category == 10
        {
            img_Hospital_set.tintColor = .clear
            
            self.image.backgroundColor = .clear
        }
        
        
    }
    
}
