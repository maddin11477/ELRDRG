//
//  MapProvider.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.03.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit
import MapKit

public enum MapProviderType : Int {
    case AppleMap = 0
    case AppleSatelite = 1
    case AppleHybrid = 2
    case OpenStreetmap = 3
    case OpenStreetMapOverlay = 4
}
public class MapProvider: NSObject {
    
    //Startup Provider
    public var provider : MapProviderType = .AppleMap
    private var map : MKMapView
    private var overlay : MKOverlay?
   
    init(mapView : MKMapView) {
        self.map = mapView
        self.map.showsTraffic = false //otherwise app may crash with additional provider
    }
    
    
    
    public func setProvider(provider : MapProviderType)
    {
        map.cameraZoomRange = MKMapView.CameraZoomRange(
          minCenterCoordinateDistance: 340,
            maxCenterCoordinateDistance: map.cameraZoomRange.maxCenterCoordinateDistance)
        //delete Tileoverlays
        if let overlay = self.overlay
        {
            self.map.remove(overlay)
        }
        self.provider = provider
        switch provider {
        case .AppleMap:
            self.map.mapType = .standard
            
        case .AppleSatelite:
            self.map.mapType = .satelliteFlyover
            
        case .AppleHybrid:
            self.map.mapType = .hybridFlyover
            
        case .OpenStreetmap:
            //change to mapType satellite to avoid double street/town labels
            self.map.mapType = .satellite
            //create custom Tileoverlay
            let overlay = OpenStreetMapOverlay()
            // Zoom needs to be bounded caused by tileprovider maximum zoom available
            overlay.maximumZ = 19
            self.overlay = overlay
            //add Tileoverlay as overlay to map
            self.map.add(overlay, level: .aboveRoads)
        
        case .OpenStreetMapOverlay:
            //change to mapType satellite to avoid double street/town labels
            self.map.mapType = .satellite
            //create custom Tileoverlay
            let overlay = OpenTopoMapProvider()
            // Zoom needs to be bounded caused by tileprovider maximum zoom available
            overlay.maximumZ = 19
            self.overlay = overlay
            //add Tileoverlay as overlay to map
            self.map.add(overlay, level: .aboveRoads)
        }
    }
    
    
    public func getTileRenderer(overlay : MKOverlay)->MKOverlayRenderer
    {
        //check if tileoverlay renderer is needed, otherwise return usual shape renderer
        if let overlay = overlay as? BaseTileOverlay
        {
            overlay.canReplaceMapContent = true
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }
        else
        {
            return MKOverlayRenderer()
        }
        
    }
    
}

