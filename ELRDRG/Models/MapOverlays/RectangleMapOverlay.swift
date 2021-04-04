//
//  RectangleMapOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 17.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import Foundation
import CoreData
import MapKit

//---->>>  NOT SUPPORTED YET
public class RectangleMapOverlay : BaseMapOverlay
{
    
    convenience init(latitude : Double, longitude : Double, width : Double, height: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.height = height
        self.width = width
    }
    
    override func getOverlays() -> [MKOverlay] {
        let list : [MKOverlay] = []
        return list
    }
}
