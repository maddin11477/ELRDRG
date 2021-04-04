//
//  MapOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 07.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

public class MapOverlay: NSManagedObject {
    public func getDrawingMapOverlay()->DrawingMapOverlay?
    {
        if let data = self.imageData
        {
            let mapPoint = MKMapPoint(x: self.frameMinX, y: self.frameMinY)
            let mapSize = MKMapSize(width: self.frameWidth, height: self.frameHeight)
            let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
            let coordinate = CLLocationCoordinate2D(latitude: self.coordinateLAT, longitude: self.coordinateLNG)
            let img = UIImage(data: data)
            let overlay = DrawingMapOverlay(drawing: img!, bounds: mapRect, coordinate: coordinate)
            return overlay
        }
        return nil
    }
    
    public static func getAllDrawingOverlays()->[DrawingMapOverlay]
    {
        let mission = DataHandler().getCurrentMission()
        var mapOverlays : [DrawingMapOverlay] = []
        if let overlays = mission?.overlays?.allObjects as? [MapOverlay]
        {
            for overlay in overlays {
                if let drawing = overlay.getDrawingMapOverlay()
                {
                    mapOverlays.append(drawing)
                }
                
            }
        }
        return mapOverlays
    }
    
    
    
    public static func toMapOverlay(drawingMapOverlay : DrawingMapOverlay)->MapOverlay
    {
       
        let overlay = MapOverlay(context: AppDelegate.viewContext)
        let image : UIImage =  drawingMapOverlay.image
        let data = UIImagePNGRepresentation(image)
        overlay.imageData = data
        overlay.coordinateLAT = drawingMapOverlay.coordinate.latitude
        overlay.coordinateLNG = drawingMapOverlay.coordinate.longitude
        overlay.frameWidth = drawingMapOverlay.boundingMapRect.width
        overlay.frameHeight = drawingMapOverlay.boundingMapRect.height
        overlay.frameMinX = drawingMapOverlay.boundingMapRect.minX
        overlay.frameMinY = drawingMapOverlay.boundingMapRect.minY
        return overlay
    }
    
    public static func deleteOverlay(overlay : MapOverlay)
    {
        
    }
}
