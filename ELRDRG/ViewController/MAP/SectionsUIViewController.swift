//
//  SectionsUIViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 30.08.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit


protocol MapSectionsProtocol {
    func DroppedSectionToMap(location : CGPoint, section : Section)
}

class SectionsUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemprovider = NSItemProvider()
        let dragitem = UIDragItem(itemProvider: itemprovider)
        dragitem.localObject = sectionList[indexPath.row]
        return [dragitem]
    }
    
    public var delegate : MapSectionsProtocol?
    
    var mapView : UIView?
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        if let view = mapView
        {
            let location = session.location(in: view)
            if let del = self.delegate {
                if let section = session.items[0].localObject as? Section
                {
                    del.DroppedSectionToMap(location: location, section: section)
                }
                
            }
            print("location: ")
            print(location)
        }
        
    }
    
    
   
    
    //Object properties
    var sectionList : [Section] = []
    
    //UI Refs
    @IBOutlet weak var table: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionList = SectionHandler().getSections()
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "MapSectionTVC") as! MapSectionTVC
        cell.setSection(section: sectionList[indexPath.row])
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.dragDelegate = self
        self.table.dragInteractionEnabled = true
        self.table.reloadData()
        
       
        
        
    }
    
    required init?(coder: NSCoder, mapView : UIView) {
          self.mapView = mapView
          super.init(coder: coder)
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    

   

}
