//
//  CircleMapOverlay.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 16.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit
import CoreData
import MapKit

public class CircleMapOverlay : BaseMapOverlay {
    //needed to add new Object to context otherwise -> crash
    
    
    
    convenience init(latitude : Double, longitude : Double, radius : Double)
    {
        self.init(latitude: latitude, longitude: longitude)
        self.radius = radius
    }
    
     override func getOverlays()->[MKOverlay]
    {
        let overlays : [MKOverlay] = []
        if radius > 0
        {
            let circle1 = MKCircle(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), radius: self.radius)
            let circle2 = MKCircle(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), radius: 5.0)
            
            
            return [circle1, circle2]
        }
        return overlays
    }
    
    
    
    override func getImage(x : Int = 303, y : Int = 128) -> UIView? {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (x/2) + 10, y: (y/2) + 15), radius: CGFloat(x/2), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        // Change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 2.0
        
        let middlePath = UIBezierPath(arcCenter: CGPoint(x: (x/2) + 10, y: (y/2) + 15), radius: CGFloat(x/15), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let middleLayer = CAShapeLayer()
        middleLayer.path = middlePath.cgPath
        middleLayer.fillColor = UIColor.red.cgColor
        middleLayer.strokeColor = UIColor.red.cgColor
        middleLayer.lineWidth = 0.2
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 303, height: 128))
        view.layer.addSublayer(shapeLayer)
        view.layer.addSublayer(middleLayer)
        let textView : UILabel = UILabel(frame: CGRect(x: (x) + 30, y: (y/2), width: Int(view.frame.width) - ((x)+30), height: 30))
        textView.text = "Radius: " + String(self.radius) + " Meter"
        
        view.addSubview(textView)
        return view
    }
    
    
}

extension MKCircle{
    public func getRenderer()->MKOverlayRenderer
    {
        let renderer = MKCircleRenderer(circle: self)
        renderer.lineWidth = 2
        if self.radius == 5
        {
            renderer.fillColor = .red
        }
        else
        {
            renderer.fillColor = .clear
        }
        
        renderer.strokeColor = .red
        return renderer
        
    }
}
