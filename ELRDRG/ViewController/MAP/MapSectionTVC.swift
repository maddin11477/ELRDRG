//
//  MapSectionTVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 30.08.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

class MapSectionTVC: UITableViewCell {
    
    //ErrorHandling
    enum ValidationError: Error {
        case emptySection
       }

    //Object properties
    var section : Section?
    @IBOutlet weak var lblSectionName: UILabel!
    
   
    public func setSection(section : Section) {
        self.section = section
        self.lblSectionName.text = section.identifier
    }
    
    public func getSection() throws->Section
    {
        if let section = self.section
        {
            return section
        }
        else
        {
            throw ValidationError.emptySection
        }
        
    }
    

}
