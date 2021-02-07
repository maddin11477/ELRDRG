//
//  DrawingOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 05.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import Foundation

import MapKit
import CoreData
public class DrawingMapOverlay: NSObject, MKOverlay {
    
     public let coordinate: CLLocationCoordinate2D
     public let boundingMapRect: MKMapRect
    public let image : UIImage
    
   
    
    init(drawing: UIImage, bounds : MKMapRect, coordinate : CLLocationCoordinate2D) {
        self.boundingMapRect = bounds
        self.coordinate = coordinate
        self.image = drawing
        super.init()
        
        let mapoverlay = MapOverlay.toMapOverlay(drawingMapOverlay: self)
        let handler = DataHandler()
        let mission = handler.getCurrentMission()
        mission?.addToOverlays(mapoverlay)
        handler.saveData()
     }
    

    
    
}

class DrawingMapOverlayView: MKOverlayRenderer {
  let overlayImage: UIImage
  
  // 1
  init(overlay: MKOverlay, overlayImage: UIImage) {
    self.overlayImage = overlayImage
    super.init(overlay: overlay)
  }
  
  // 2
  override func draw(
    _ mapRect: MKMapRect,
    zoomScale: MKZoomScale,
    in context: CGContext
  ) {
    guard let imageReference = overlayImage.cgImage else { return }
    
    let rect = self.rect(for: overlay.boundingMapRect)
    context.scaleBy(x: 1.0, y: -1.0)
    context.translateBy(x: 0.0, y: -rect.size.height)
    context.draw(imageReference, in: rect)
  }
}
