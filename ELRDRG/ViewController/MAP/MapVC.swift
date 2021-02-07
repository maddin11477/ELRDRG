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
import PencilKit




class MapVC: UIViewController, CLLocationManagerDelegate, SectionAnnotationViewDelegate, MKMapViewDelegate, MapSectionsProtocol, SectionMapAnnotationDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func removeSection(section: Section?) {
        //not needed
    }
    
    
    func annoationdeleted(annotation: SectionMapAnnotation) {
            //Section deleted -> SEctionAnnotation has to be removed also
            self.mapView.removeAnnotation(annotation)
        
        
    }
    var canvasView : PKCanvasView?
    var window : UIWindow?
    var toolPicker : PKToolPicker?
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
            if let mapDrawing = overlay as? DrawingMapOverlay
            {
                return DrawingMapOverlayView(overlay: overlay, overlayImage: mapDrawing.image)
            }
        return MKOverlayRenderer()
    }
    
    @IBAction func createScreenShotToDocu(_ sender: Any)
    {
        
        let render = UIGraphicsImageRenderer(size: self.mapView.bounds.size)
        let image = render.image { ctx in
          self.mapView.drawHierarchy(in: self.mapView.bounds, afterScreenUpdates: true)
        }
        
        DocumentationHandler().SavePhotoDocumentation(picture: image, description: "Ausschnitt aus Lagekarte", saveDate: Date())
        var userName = "unbekannt"
        if let user = LoginHandler().getLoggedInUser()
        {
            userName = (user.firstName ?? "") + " " + (user.lastName ?? "")
        }
        let _ = DataHandler().createNotification(sender: userName, content: "Lagekartenausschnitt wurde dem Tagebuch hinzugefügt")
            
        
        
    }
    var drawingEnabled : Bool = false
    
    //Enables and disables Drawing
    @IBAction func enableDrawing(_ sender: Any) {
        
        cmdEnableDrawing.image = UIImage(systemName: "pencil")
        draw()
        disableDrawing()
        removeNavigationBar()
        draw()
        drawingEnabled = true
        
    }
    
    @IBOutlet weak var cmdEnableDrawing: UIBarButtonItem!
    
    func disableDrawing()
    {
        
        if let view = canvasView
        {
            view.removeFromSuperview()
            toolPicker?.removeObserver(self.canvasView!)
        }
        cmdEnableDrawing.style = .plain
        
        cmdEnableDrawing.image = UIImage(systemName: "pencil")
        
        
    }
    
    func draw()
    {
        
        let frame = CGRect(x: mapView.frame.minX, y: mapView.frame.minY - 30, width: mapView.frame.width, height: mapView.frame.height)
        let canvasView = PKCanvasView(frame: frame)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
                canvasView.isOpaque = false
                
                
        canvasView.backgroundColor = .clear
                view.addSubview(canvasView)
               
        
        self.canvasView = canvasView
        setNavigationBar()
        
        guard let window = view.window,
        let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: self.canvasView!)
        
        toolPicker.addObserver(self.canvasView!)
        
        canvasView.becomeFirstResponder()
        
        //self.viewDidAppear(true)
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
        
        //cmdEnableDrawing.image = UIImage(systemName: "Pencil")
        cmdEnableDrawing.style = .plain
        cmdEnableDrawing.image = UIImage(systemName: "pencil")
        //cmdEnableDrawing.title = "Zeichnen"
        self.navigationItem.leftBarButtonItem = cmdEnableDrawing
        //SectionTable
        self.sectionTable.dataSource = self
        self.sectionTable.delegate = self
        self.sectionTable.dragDelegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        
        mapView.delegate = self
        mapView.isRotateEnabled = false
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
        
        //Load Drawings
        mapView.addOverlays(MapOverlay.getAllDrawingOverlays())
    }
    
    
    func beginDrawing()
    {
        if #available(iOS 13.0, *) {
             let canvasView = PKCanvasView(frame: self.view.bounds)
             guard
             let window = view.window,
             let toolPicker = PKToolPicker.shared(for: window) else { return }
            
             toolPicker.setVisible(true, forFirstResponder: canvasView)
             toolPicker.addObserver(canvasView)
             canvasView.becomeFirstResponder()
          canvasView.backgroundColor = .clear
             view.addSubview(canvasView)
        } else {
             // Fallback on earlier versions
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated) // Manquait
       
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
    
    
    private var setRegion : Bool = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
       
        self.locationManager.stopUpdatingLocation()
        if !setRegion
        {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            self.mapView.setRegion(region, animated: true)
            setRegion = true
        }
        
        
        selfPin.coordinate = locations[0].coordinate
        
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
       
        
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if let marker = annotation as? SectionMapAnnotation
           {
               let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "TestAnnotation")
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
    
    var toggleDrawItem : UIBarButtonItem!
    var saveImageBtn : UIBarButtonItem!
    var disableDraw : Bool = false
    var navigationBar : UINavigationBar?
    
    @objc func dragDrawToggler(){
        
        //DragOrDraw.disableDrawing = !DragOrDraw.disableDrawing
        disableDrawing()
        removeNavigationBar()
    }
    
    func clippedImageForRect(clipRect: CGRect, inView view: UIView) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(clipRect.size, true, UIScreen.main.scale)
            if let ctx = UIGraphicsGetCurrentContext(){
                ctx.translateBy(x: -clipRect.origin.x, y: -clipRect.origin.y);
                view.layer.render(in: ctx)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return img
            }
            return nil
    }
    
    @objc func saveDrawing()
    {
        if let view = canvasView
        {
            let frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - 8)
            print("CanvasViewHeight:")
            print(frame.height)
            print("CanvasViewWidth:")
            print(frame.width)
            let image = view.drawing.image(from: frame, scale: 1.0)
            //var maprect = mapView.visibleMapRect
            
            let overlay = DrawingMapOverlay(drawing: image, bounds: mapView.visibleMapRect, coordinate: mapView.centerCoordinate)
            print("MapRectHeight:")
            print(mapView.visibleMapRect.height)
            print("MapRectWidth:")
            print(mapView.visibleMapRect.width)
            
            mapView.add(overlay)
        }
        
        disableDrawing()
        removeNavigationBar()
    }
    
    
    
    func setNavigationBar() {

        toggleDrawItem = UIBarButtonItem(title: "zurück", style: .plain, target: self, action: #selector(dragDrawToggler))
        //toggleDrawItem.image = UIImage(systemName: "pencil.slash")
        saveImageBtn = UIBarButtonItem(title: "Speichern", style: .plain, target: self, action: #selector(saveDrawing))
    let navigationItem = UINavigationItem(title: "Zeichnen")
    
    navigationItem.leftBarButtonItem = toggleDrawItem
    navigationItem.leftBarButtonItem?.image = UIImage(systemName: "pencil.slash")
        navigationItem.rightBarButtonItem = saveImageBtn
    navigationBar = UINavigationBar(frame: .zero)
    navigationBar?.isTranslucent = false
        navigationBar!.largeContentTitle = "Zeichnen"
    navigationBar!.setItems([navigationItem], animated: false)
    navigationBar!.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(navigationBar!)
    navigationBar!.backgroundColor = .clear
    NSLayoutConstraint.activate([
    navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    navigationBar!.heightAnchor.constraint(equalToConstant: 60),
    navigationBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    navigationBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    }
    
    func removeNavigationBar()
    {
        navigationBar?.removeFromSuperview()
        cmdEnableDrawing.style = .bordered
        //cmdEnableDrawing.image = UIImage(systemName: "pencil.slash")
        self.navigationItem.leftBarButtonItem = cmdEnableDrawing
        
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

extension PKCanvasView{
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return DragOrDraw.disableDrawing
    }
    
    
    
    
}

class DragOrDraw{
    static var disableDrawing = true
}


