//
//  MapVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 03.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapVC: UIViewController, CLLocationManagerDelegate, SectionAnnotationViewDelegate, MKMapViewDelegate, MapSectionsProtocol, SectionMapAnnotationDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func removeSection(section: Section?) {
        //not needed
    }
    
    
    func annoationdeleted(annotation: SectionMapAnnotation) {
            //Section deleted -> SEctionAnnotation has to be removed also
            self.mapView.removeAnnotation(annotation)
        
        
    }
    
    @IBOutlet weak var inProgressIndicator: UIActivityIndicatorView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionList = SectionHandler().getSections()
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sectionTable.dequeueReusableCell(withIdentifier: "MapSectionTVC") as! MapSectionTVC
        cell.setSection(section: sectionList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemprovider = NSItemProvider()
        let dragitem = UIDragItem(itemProvider: itemprovider)
        dragitem.localObject = sectionList[indexPath.row]
        return [dragitem]
    }
    
    //Object properties
    var sectionList : [Section] = []
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        if let view = mapView
        {
            self.inProgressIndicator.startAnimating()
            self.inProgressIndicator.isHidden = false
            let location = session.location(in: view)
            
            if let section = session.items[0].localObject as? Section
            {
                
                self.DroppedSectionToMap(location: location, section: section)
            }
                
           
            print("location: ")
            print(location)
        }
        
    }
    
    
    func annoationChanged() {
        self.mapView.autoresizesSubviews = true
        
        SectionMapAnnotation.reloadDatas()
        mapView.reloadInputViews()
    }
    
    var indicator : UIActivityIndicatorView?
    
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet weak var sidebarButton: UIButton!
    
    @IBOutlet weak var sectionTableWidth: NSLayoutConstraint!
   
    
    func showIndicator(location : CGPoint)->UIActivityIndicatorView
    {
        //TODO
        //funktioniert irgendwie noch nicht
        let progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .large)
        progressIndicator.isHidden = false
        progressIndicator.center = self.view.center
        self.view.addSubview(progressIndicator)
        progressIndicator.startAnimating()
        return progressIndicator
    }
    
    func DroppedSectionToMap(location: CGPoint, section : Section) {
       
        self.inProgressIndicator.startAnimating()
        self.inProgressIndicator.isHidden = false
        

        
       
        if location.x < self.mapView.frame.minX || location.x > self.mapView.frame.maxX
        {
            print("dropped Outside the map frame (x)")
            return // dropped outside the mapviewframe
        }
        else if location.y < self.mapView.frame.minY || location.y > self.mapView.frame.maxY
        {
            print("dropped Outside the map frame (y)")
            return // dropped outside the mapViewFrame
        }
        
        DispatchQueue.global(qos: .background).async {
        let coordinatelocation = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        section.coordinate_lng = coordinatelocation.longitude
        section.coordinate_lat = coordinatelocation.latitude
        if let an = section.mapAnnotation
        {
            // Marker existiert bereits
            an.coordinate = CLLocationCoordinate2D(latitude: section.coordinate_lat, longitude: section.coordinate_lng)
            for annotation in self.mapView.annotations {
                if let anno = annotation as? SectionMapAnnotation
                {
                    if anno.section == section
                    {
                        print("removed")
                        DispatchQueue.main.sync {
                            self.mapView.removeAnnotation(annotation)
                            self.mapView.addAnnotation(anno)
                        }
                        
                        
                    }
                }
            }
            
            
            //an.reloadData()
        }
        else
        {
            // neuen Marker hinzufügen
            let annotation = SectionMapAnnotation(section: section)
            section.mapAnnotation = annotation
            annotation.delegate = self
            DispatchQueue.main.async {
                annotation.reloadData()
                self.addAnnotationOnLocation(section: section)
            }
            
            
        }
            DataHandler().saveData()
            DispatchQueue.main.sync {
                self.mapView.reloadInputViews()
                
                self.inProgressIndicator.stopAnimating()
                self.inProgressIndicator.isHidden = true
            }
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //updateMapContent()
    }
    let sidebarposition = 300
    @IBAction func showSideBar_Click(_ sender: Any) {
        
        let btn : UIButton = sender as! UIButton
        if(sectionTableWidth.constant == CGFloat(sidebarposition))
        {
            btn.setTitle("", for: .normal)
            sectionTableWidth.constant = 0
        }
        else
        {
            btn.setTitle("", for: .normal)
            sectionTableWidth.constant = CGFloat(sidebarposition)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func animate()
    {
        sectionTableWidth.constant = sectionTableWidth.constant
        UIView.animate(withDuration: 0.3){
           // self.view.layoutIfNeeded()
            //self.view.layoutSubviews()
        }
    }
    


    let locationManager = CLLocationManager()
    let selfPin = MKPointAnnotation()
    
    @IBAction func SegementControllChanged(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
   
    @IBSegueAction func sectionsController(_ coder: NSCoder) -> SectionsUIViewController? {
        print("segue")
        let controller = SectionsUIViewController(coder: coder, mapView: self.mapView)
        controller?.delegate = self
        return controller
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
	var sections : [Section] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //SectionTable
        self.sectionTable.dataSource = self
        self.sectionTable.delegate = self
        self.sectionTable.dragDelegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        
        mapView.delegate = self
		let view = SectionAnnotationView()
		view.delegate = self
		self.sections = SectionHandler().getSections()
		
        
         self.sectionTableWidth.constant = 0
        
        self.sections = SectionHandler().getSections()
        for section in self.sections {
            if section.coordinate_lat != 0.0 && section.coordinate_lng != 0.0
            {
                addAnnotationOnLocation(section: section)
            }
        }
        
        
        
        

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateMapContent()
    }
    
    func updateMapContent()
    {
        
            if CLLocationManager.locationServicesEnabled()
            {
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
                mapView.showsTraffic = true
                //mapView.showsPointsOfInterest = true
                
            }
            self.sectionTable.reloadData()
            self.mapView.reloadInputViews()
            self.reloadInputViews()
            for annotation in self.mapView.annotations
            {
                if let an = annotation as? SectionMapAnnotation
                {
                    an.reloadData()
                }
            }
                
            
            
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
       
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
        
        selfPin.coordinate = locations[0].coordinate
        //mapView.addAnnotation(selfPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLongPress (gesture: UILongPressGestureRecognizer) {
       /* if gesture.state == UIGestureRecognizerState.began {
            let touchPoint: CGPoint = gesture.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
          
                //addAnnotationOnLocation(pointedCoordinate: newCoordinate)
            mapView.reloadInputViews()
            updateSectionMarkers()
            
        }*/
    }
    
    func addAnnotationOnLocation(section : Section) {
        
       // let sections = DataHandler().getCurrentMission()?.sections?.allObjects as! [Section]
        let location = CLLocationCoordinate2D(latitude: section.coordinate_lat, longitude: section.coordinate_lng)
        let annotation = SectionMapAnnotation(section: section)
        annotation.coordinate = location
        annotation.title = section.identifier ?? ""
        
        annotation.subtitle = "test"
        annotation.delegate = self
        mapView.addAnnotation(annotation)
        section.mapAnnotation = annotation
       updateMapContent()
        //updateSectionMarkers()
        //SectionMapAnnotation.reloadDatas()
        //mapView.reloadInputViews()
        
    }
    
    func updateSectionMarkers()
    {
        let markers = self.mapView.annotations
        for marker in markers {
            if let annoation = marker as? SectionMapAnnotation
            {
                annoation.reloadData()
            }
        }
    }
    
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if let marker = annotation as? SectionMapAnnotation
           {
               let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "TestAnotation")
            print("subviews: ")
            print(annotationView.subviews.count)
               if annotationView.subviews.count > 0
               {
                annotationView.reloadInputViews()
               }
               else
               {
                annotationView.addSubview(marker.getAnnotationUIView())
               }
               //
               marker.reloadData()
               return annotationView
           }
           else
           {
            print(annotation.title as Any)
               return nil
           }
          
           
           
       }
    
    
    
    
   

}




extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}


