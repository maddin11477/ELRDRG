//
//  SectionMapAnnotation.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 21.08.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import MapKit

public protocol SectionMapAnnotationDelegate {
     func annoationChanged()
    func annoationdeleted(annotation : SectionMapAnnotation)
}

 public class SectionMapAnnotation : MKPointAnnotation, UITableViewDelegate, UITableViewDataSource
{
    public var delegate : SectionMapAnnotationDelegate?
    static var sectionAnnotationList : [SectionMapAnnotation] = []
    var units : [Unit] = []
    
    public static func delete(annotation : SectionMapAnnotation)
    {
        let index = sectionAnnotationList.index(of: annotation)
        if let _ = index
        {
            sectionAnnotationList.remove(at: index!)
            annotation.delegate?.annoationdeleted(annotation: annotation)
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = SectionHandler().getSections()
        for current_section in sections
        {
            if let sectionIdentifier = self.section.identifier
            {
                if current_section.identifier! == self.section.identifier!
                {
                    self.section = current_section
                }
            }
            
        }
        print("numberOfRowsinSection")
        self.units = self.section.getAllUnits()
        setTableHeight()
        return self.units.count
    }
    
    public static func reloadDatas()
    {
        
        for marker in sectionAnnotationList
        {
            marker.reloadData()
        }
        
        
        
    }
    
   
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "UnitCell") as! UnitMapTableViewCell
        cell.img.image = UIImage(named: UnitHandler().BaseUnit_To_UnitTypeString(id: self.units[indexPath.row].type))
        //cell.img = self.units[indexPath.row]
        cell.callSign.text =  " " + (self.units[indexPath.row].callsign ?? "failUnit")
        //cell.callSign.backgroundColor = UIColor.blue
        cell.backgroundColor = UIColor.orange
    
        
        return cell
    }
    
    
    public func reloadData()
    {
        
        self.table.dataSource = self
        self.table.delegate = self
        DispatchQueue.main.async {
            self.table.reloadData()
        }
       // self.table.reloadData()
        
        
        
    }
    
    public var section : Section
    public var table : UITableView
    public var headline : UILabel
    var image : UIImage = UIImage(systemName: "rectangle.stack.fill") ?? UIImage(named: "iuk.png")!
    public var annotationview : UIView?
    
    public func getTable()->UIView
    {
        return table
    }
    
    public func getAnnotationUIView()->UIView
    {
        if let view = self.annotationview
        {
            return view
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 300))
        //x:-75 zuvor
        self.table.frame = CGRect(x: -75, y: 21, width: 217, height: 100)
       
        table.backgroundColor = .white
        table.backgroundView?.backgroundColor = .white
        //x: -70
         let imageView = UIImageView(frame: CGRect(x: -70, y: 2, width: 17, height: 17))
        imageView.image = self.image
        imageView.tintColor = UIColor.black
        imageView.backgroundColor = UIColor.white
        // headline: -54
        self.headline.frame = CGRect(x: -54, y: 0, width: 200, height: 21)
        self.headline.backgroundColor = UIColor.white
        self.headline.tintColor = UIColor.black
        self.headline.textColor = UIColor.black
        setTableHeight()
        //x: -75
        let backgroundView = UIView(frame: CGRect(x: -75, y: 0, width: 150, height: 21))
        backgroundView.backgroundColor = UIColor.white
        view.addSubview(backgroundView)
        view.addSubview(self.table)
        view.addSubview(self.headline)
        view.addSubview(imageView)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        
        
        self.annotationview = view
        return view
    }
    
    func setTableHeight()
    {
        
        let height = self.units.count * 21
        //x: -75
        
        self.table.frame = CGRect(x: -75, y: 21, width: 222, height: height)
        
    
        
        self.table.backgroundView?.backgroundColor = UIColor.red
        self.table.backgroundColor = UIColor.green
        
    }
    
    
    
    init(section : Section)
    {
        
        self.section = section
        
        for annotation in SectionMapAnnotation.sectionAnnotationList {
            if annotation.section == self.section
            {
               
                if let index = SectionMapAnnotation.sectionAnnotationList.index(of: annotation)
                {
                    SectionMapAnnotation.sectionAnnotationList.remove(at: index)
                    self.delegate?.annoationdeleted(annotation: annotation)
                }
                
            }
        }
        // self.units =  self.section.getAllUnits()
       
        self.headline = UILabel(frame: CGRect(x: 0, y: 0, width: 183, height: 30))
        self.headline.backgroundColor = .lightGray
        self.headline.text = "  " + (section.identifier ?? "")
        self.table = UITableView(frame: CGRect(x: 0, y: 0, width: 183, height: 50))
        self.table.register(UnitMapTableViewCell.self, forCellReuseIdentifier: "UnitCell")
        super.init()
         self.coordinate = CLLocationCoordinate2D(latitude: section.coordinate_lat, longitude: section.coordinate_lng)
        //notify static class
        SectionMapAnnotation.sectionAnnotationList.append(self)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.rowHeight = 21
        //self.table.reloadData()
        
        setTableHeight()
        self.section.mapAnnotation = self
        
        
        
        
    }
    
   
    
    
}

 
