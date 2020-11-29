//
//  UnitMapTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.08.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import UIKit
public class UnitMapTableViewCell : UITableViewCell
{
    let img = UIImageView()
    let callSign = UILabel()
    let patient = UILabel()
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            img.translatesAutoresizingMaskIntoConstraints = false
            callSign.layoutMargins.left = 0
            callSign.layoutMargins.top = 0
            callSign.layoutMargins.right = 0
            callSign.layoutMargins.bottom = 0
            callSign.frame = CGRect(x: 0, y: 0, width: 150, height: 21)
            img.frame = CGRect(x: 150, y: 0, width: 70, height: 21)
            //callSign.sizeToFit()
            callSign.translatesAutoresizingMaskIntoConstraints = false
            patient.translatesAutoresizingMaskIntoConstraints = false
            
            //contentView.addSubview(img)
            contentView.addSubview(callSign)
            //contentView.addSubview(patient)
            callSign.text = "DUMMY"
              
    }
    
    public required init?(coder: NSCoder) {
        fatalError("fatal Error UnitMapTableViewCell : init NSCoder")
    }
}
