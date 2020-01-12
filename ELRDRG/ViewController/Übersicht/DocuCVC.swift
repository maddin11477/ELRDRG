//
//  DocuCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 09.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class DocuCVC: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    var entries : [Documentation] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.layoutMargins.top = 20
        self.clipsToBounds = true
        self.layoutMarginsDidChange()
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextDocuTVC") as! TextDocuTVC
        cell.setup(entry: entries[indexPath.row])
        return cell
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    public func setup()
    {
        tableView.dataSource = self
        tableView.delegate = self
        self.layoutMargins.top = 20
        layoutMarginsDidChange()
        entries = DocumentationHandler().getAllDocumentations()
        
        //Filter nach Einträgen mit Text da V0.1 nur Texteinträge in der Übersicht anzeigt
        entries = entries.filter{
            if let content = $0.content
            {
                if(content.isEmpty)
                {
                    return false
                }
                return true
            }
            else
            {
                return false
            }
        }
        
        tableView.reloadData()
        
    }
    
    
}
