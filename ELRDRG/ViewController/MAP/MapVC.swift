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

public protocol MapVCdelegate {
    func addedOverlay(overlay : DrawingMapOverlay)
    func addedOverlay(overlay : BaseMapOverlay)
    func reloadOverlays()
}


class MapVC: UIViewController, CLLocationManagerDelegate, SectionAnnotationViewDelegate, MKMapViewDelegate, MapSectionsProtocol, SectionMapAnnotationDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, overlayListViewControllerDelegate {
    func deletedBaseOverlay(overlay: BaseMapOverlay) {
        loadOverlays()
    }
    
    func didSelectBaseOverlay(overlay: BaseMapOverlay) {
        self.mapView.setCenter(overlay.getCoordinate(), animated: true)
    }
    
    func deletedOverlay(overlay: DrawingMapOverlay) {
        loadOverlays()
        print("MAPVC deletedMapOverlay")
    }
    
    func reloadOverlays() {
        loadOverlays()
    }
    
    func didSelectOverlay(overlay: DrawingMapOverlay) {
        self.mapView.setCenter(overlay.coordinate, animated: true)
    }
    
    func removeSection(section: Section?) {
        //not needed
    }
    
    public static var controller : MapVC?
    public var overlayLVC : overlayListViewController?
    
     func annoationdeleted(annotation: SectionMapAnnotation) {
            //Section deleted -> SEctionAnnotation has to be removed also
            self.mapView.removeAnnotation(annotation)
    }
    var canvasView : PKCanvasView?
    var window : UIWindow?
    var toolPicker : PKToolPicker?
    public var delegate : MapVCdelegate?
    
    @IBOutlet weak var overlayListWidth: NSLayoutConstraint!
    
    @IBOutlet weak var cmdOverlaySlide: UIButton!
    
    func overlayListSlideLeft(animated : Bool = true)
    {
        //HIDE <<---
        overlayListWidth.constant = 0
        cmdOverlaySlide.setImage(UIImage(systemName: "rectangle.righthalf.inset.fill.arrow.right"), for: .normal)
        
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func overlayListSlideRight(animated : Bool = true)
    {
        //SHOW ---->>
        overlayListWidth.constant = 300
        cmdOverlaySlide.setImage(UIImage(systemName: "rectangle.lefthalf.inset.fill.arrow.left"), for: .normal)
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    
    @IBAction func overlayListSlide(_ sender: Any) {
        
        if overlayListWidth.constant > 0
        {
            overlayListSlideLeft()
            
        }
        else
        {
            overlayListSlideRight()
        }
        
    }
    
    @IBAction func printMap(_ sender: Any) {
        //Screenshot of view controller (minus status/Nav bar)
        self.mapView.showsUserLocation = false
            sectionTableSlideRight(button: nil, animated: false)
            overlayListSlideLeft(animated: false)
        while(overlayListWidth.constant > 0 && sectionTableWidth.constant > 0)
            {
                sleep(2000)
            }
                    
            
            let render = UIGraphicsImageRenderer(size: self.mapView.bounds.size)
            
            let image = render.image { ctx in
              self.mapView.drawHierarchy(in: self.mapView.bounds, afterScreenUpdates: true)
            }

           ///Print screenshot
           let printController = UIPrintInteractionController.shared
           let printInfo = UIPrintInfo(dictionary:nil)

           printInfo.jobName = "printing an image"
           printInfo.outputType = .photo

           printController.printInfo = printInfo
           printController.printingItem = image
           printController.present(animated: true)  { (_, isPrinted, error) in if error == nil {
               if isPrinted {
                   print("image is printed")
               }else{
                   print("image is not printed")
               }
               }
           }
        self.mapView.showsUserLocation = true

    }
    
    
    @IBAction func addCircle(_ sender: Any) {
       
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
            if let mapDrawing = overlay as? DrawingMapOverlay
            {
                return DrawingMapOverlayView(overlay: overlay, overlayImage: mapDrawing.image)
            }
            else if let circle = overlay as? MKCircle
            {
                return circle.getRenderer()
            }
            
        
        if let mapProvider = self.mapProvider, let _ = overlay as? BaseTileOverlay
        {
            return mapProvider.getTileRenderer(overlay: overlay)
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
        overlayListSlideLeft()
        sectionTableSlideRight(button: sidebarButton)
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
    
    func sectionTableSlideLeft(button : UIButton? = nil, animated : Bool = true)
    {
        self.sidebarButton.setImage(UIImage(systemName: "rectangle.righthalf.inset.fill.arrow.right"), for: .normal)
        //btn.setTitle("", for: .normal)
        sectionTableWidth.constant = CGFloat(sidebarposition)
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func sectionTableSlideRight(button : UIButton? = nil, animated : Bool = true)
    {
        if button == nil
        {
            self.sidebarButton.setImage(UIImage(systemName: "rectangle.lefthalf.inset.fill.arrow.left"), for: .normal)
        }
        else
        {
            button?.setImage(UIImage(systemName: "rectangle.lefthalf.inset.fill.arrow.left"), for: .normal)
        }
        
        //btn.setTitle("", for: .normal)
        sectionTableWidth.constant = 0
        if animated
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    @IBAction func showSideBar_Click(_ sender: Any) {
        
        let btn : UIButton = sender as! UIButton
        if(sectionTableWidth.constant == CGFloat(sidebarposition))
        {
            
            sectionTableSlideRight(button: btn)
        }
        else
        {
           sectionTableSlideLeft(button: btn)
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
    

    var mapProvider : MapProvider?
    let locationManager = CLLocationManager()
    let selfPin = MKPointAnnotation()
    
    @IBAction func SegementControllChanged(_ sender: UISegmentedControl) {
        if let provider = self.mapProvider, let providerType = MapProviderType.init(rawValue: sender.selectedSegmentIndex)
        {
            
            provider.setProvider(provider: providerType)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(self.mapView.camera.centerCoordinateDistance)
    }
   
    @IBSegueAction func sectionsController(_ coder: NSCoder) -> SectionsUIViewController? {
        print("segue")
        let controller = SectionsUIViewController(coder: coder, mapView: self.mapView)
        controller?.delegate = self
        return controller
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
	var sections : [Section] = []
    var scale : MKScaleView?
    
    func showScale(visible : Bool)
   {
        if let scale = self.scale
        {
            scale.scaleVisibility = visible ? .visible : .visible
        }
        else
        {
            self.scale = MKScaleView(mapView: mapView)
            self.scale?.scaleVisibility = .visible
            self.mapView.addSubview(self.scale!)
            
            self.scale!.translatesAutoresizingMaskIntoConstraints = false
            let horizontal = self.scale!.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor, constant: 20)
            let vertical = self.scale!.topAnchor.constraint(equalTo: self.mapView.topAnchor, constant: 20)
            NSLayoutConstraint.activate([horizontal,vertical])
            self.showScale(visible: visible)
            
        }
        
   }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScale(visible: true)
        self.mapProvider = MapProvider(mapView: self.mapView)
        self.mapProvider?.setProvider(provider: .AppleMap)
        MapVC.controller = self
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.mapView.addGestureRecognizer(longPressRecognizer)

        
        loadOverlays()
        overlayListSlideLeft()
        sectionTableSlideRight(button: sidebarButton)
    }
    
    
    var position : CLLocationCoordinate2D?
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.began {
            let tempPos = gestureReconizer.location(in: self.mapView)
            position = self.mapView.convert(tempPos, toCoordinateFrom: mapView)
            let controller = UIAlertController(title: "Wähle Aktion", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Kreis hinzufügen", style: .default, handler: {
                action in
                self.addCircle()
            })
            controller.addAction(action)
            let abort = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil )
            controller.addAction(abort)
            self.present(controller, animated: true, completion: nil)
        }
            
    }
    
    func addCircle()
    {
        print("addcircle")
        if let _ = position
        {
            var text_Field : UITextField?
            let alertController = UIAlertController(title: "Kreis hinzufügen", message: "Geben Sie den gewünschten Radius in Meter [m] an", preferredStyle: .alert)
            alertController.addTextField{
                textField in
                textField.textAlignment = .center
                textField.keyboardType = .numberPad
                text_Field = textField
                
            }
            let addcircle = UIAlertAction(title: "Hinzufügen", style: .default, handler: {
                action in
                let radius = Double(text_Field?.text ?? "500") ?? 500.0
                
                if let pos = self.position
                {
                    let circleOverlay = CircleMapOverlay(latitude: pos.latitude, longitude: pos.longitude, radius: radius)
                    self.mapView.addOverlays(circleOverlay.getOverlays())
                    self.delegate?.addedOverlay(overlay: circleOverlay)
                }
            })
            alertController.addAction(addcircle)
            let abort = UIAlertAction(title: "Abbrechen", style: .cancel, handler: {
            aciton in
                self.position = nil
            })
            alertController.addAction(abort)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func loadOverlays()
    {
        //remove all Overlays but not tiles
        for overlay in mapView.overlays {
            if let _ = overlay as? MKTileOverlay
            {
                
            }
            else
            {
                mapView.remove(overlay)
            }
        }
       // mapView.removeOverlays(mapView.overlays)
        mapView.addOverlays(MapOverlay.getAllDrawingOverlays())
        
        //mapView.addOverlays(CircleMapOverlay(radius: 500.0).getOverlay())
        mapView.addOverlays(BaseMapOverlay.getAllOverlays())
        
        mapView.reloadInputViews()
        
        
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
        self.overlayLVC = overlayListViewController.controller
        self.overlayLVC?.delegate = self
        
                  
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
            
            let image = view.drawing.image(from: frame, scale: 1.0)
        
            let overlay = DrawingMapOverlay(drawing: image, bounds: mapView.visibleMapRect, coordinate: mapView.centerCoordinate)
            //save the new drawing to the current mission
            overlay.saveToMission()
            
            
            mapView.add(overlay)
            self.delegate?.addedOverlay(overlay: overlay)
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
        cmdEnableDrawing.style = .plain
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


