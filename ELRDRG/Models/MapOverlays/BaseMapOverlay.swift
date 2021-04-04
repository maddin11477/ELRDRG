//
//  BaseMapOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 16.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//


import UIKit
import CoreData
import MapKit

protocol BaseMapOverlayDelegate {
    func getOverlays()->[MKOverlay]
    func getImage(x : Int, y : Int)->UIView?
}

public class BaseMapOverlay : NSManagedObject, BaseMapOverlayDelegate {
    
    @objc func getImage(x : Int = 100, y : Int = 100) -> UIView? {
        return nil
    }
    
    public func getCoordinate()->CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    public static func getAllOverlays()->[MKOverlay]
    {
        var list : [MKOverlay] = []
        
        if let mission = DataHandler().getCurrentMission(), let overlays = mission.baseMapOverlays?.allObjects as? [BaseMapOverlay]
        {
            for overlay in overlays {
                for ov in overlay.getOverlays() {
                    list.append(ov)
                }
            }
        }
        return list
        
    }
    
    convenience init()
    {
        self.init(context: AppDelegate.viewContext)
        
    }
    
    convenience init(latitude : Double, longitude : Double) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
        let handler = DataHandler()
        let mission = handler.getCurrentMission()
        self.mission = mission
        self.mission?.addToBaseMapOverlays(self)
        handler.saveData()
        
    }
    
    @objc func getOverlays() -> [MKOverlay] {
        //NOT IMPLEMENTED
        return []
    }
}


