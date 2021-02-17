//
//  overlayListViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 12.02.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit



protocol overlayListViewControllerDelegate {
    func deletedOverlay(overlay : DrawingMapOverlay)
    func deletedBaseOverlay(overlay : BaseMapOverlay)
    func reloadOverlays()
    func didSelectOverlay(overlay : DrawingMapOverlay)
    func didSelectBaseOverlay(overlay : BaseMapOverlay)
}


class overlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MapVCdelegate {
    func addedOverlay(overlay: BaseMapOverlay) {
        overlayTableView.reloadData()
    }
    
    public static var controller : overlayListViewController?
    var mapVC : MapVC?
    public var delegate : overlayListViewControllerDelegate?
    
    @IBOutlet weak var overlayTableView: UITableView!
    
    var overlayList : [DrawingMapOverlay] = []
    var baseOverlays : [BaseMapOverlay] = []
    
    var dataHandler = DataHandler()
    
    //Delegates
    
    func addedOverlay(overlay: DrawingMapOverlay) {
        overlayTableView.reloadData()
    }
    
    func reloadOverlays() {
        overlayTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //basemapoverlay section
            let cell = self.overlayTableView.dequeueReusableCell(withIdentifier: "BaseMapOverlayTVC") as! BaseMapOverlayTVC
            cell.set(overlay: self.baseOverlays[indexPath.row])
            return cell
        case 1:
            //Drawings
            let cell = self.overlayTableView.dequeueReusableCell(withIdentifier: "overlayTVC") as! overlayTVC
            cell.overlayImage.image = overlayList[indexPath.row].image
            return cell
        default:
            return UITableViewCell() // Not more sections supported
        }
       
        
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Geometrische Overlays"
        case 1:
            return "Zeichnungen"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            //BaseMapOverlays
            if let overlays = self.dataHandler.getCurrentMission()?.baseMapOverlays?.allObjects as? [BaseMapOverlay]
            {
                self.baseOverlays = overlays
                return self.baseOverlays.count
            }
        }
        else
        {
            //Drawings
            overlayList = MapOverlay.getAllDrawingOverlays()
            return overlayList.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //doing something with the basemapoverlay
            print("not implemented")
            self.delegate?.didSelectBaseOverlay(overlay: baseOverlays[indexPath.row])
        case 1:
            self.delegate?.didSelectOverlay(overlay: overlayList[indexPath.row])
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let handler = DataHandler()
        let mission = handler.getCurrentMission()
        switch indexPath.section {
        case 0:
            print("not implemented")
            if let overlays = mission?.baseMapOverlays?.allObjects as? [BaseMapOverlay]
            {
                mission?.removeFromBaseMapOverlays(overlays[indexPath.row])
                handler.saveData()
                self.delegate?.deletedBaseOverlay(overlay: baseOverlays[indexPath.row])
                AppDelegate.viewContext.delete(baseOverlays[indexPath.row])
                self.overlayTableView.reloadData()
            }
        case 1:
            if let overlays = mission?.overlays?.allObjects as? [MapOverlay]
            {
                mission?.removeFromOverlays(overlays[indexPath.row])
                
                handler.saveData()
                self.delegate?.deletedOverlay(overlay: overlayList[indexPath.row])
                AppDelegate.viewContext.delete(overlays[indexPath.row])
                self.overlayTableView.reloadData()
                
                print("deleted")
            }
        default:
            return //no more sections supported
        }
        
       
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayTableView.dataSource = self
        overlayTableView.delegate = self
        overlayTableView.reloadData()
        overlayListViewController.controller = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapVC = MapVC.controller
        self.mapVC?.delegate = self
        
    }

}
