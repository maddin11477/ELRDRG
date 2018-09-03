//
//  DocumentationVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DocumentationProtocol {

    
    var documentations : [Documentation] = []
    var docuHandler = DocumentationHandler()
    
    @IBOutlet weak var documentationList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentationList.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
        cell.ID.text = String(documentations[indexPath.row].id)
        cell.Content.text = documentations[indexPath.row].content
        return cell
    }
    
    //protocol for delegation
    func updatedMDocumentationList(docuList: [Documentation]) {
        
        documentations = docuList
        documentations.sort(by: {$0.id > $1.id})
        documentationList.reloadData()
        self.presentedViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        documentations = docuHandler.getAllDocumentations()
        
        documentationList.reloadData()
        print("DocuVC sollte jetzt eigentlich \(documentations.count) Daten anzeigen...")
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DocumentationHandler.delegate = self
        //docuHandler.delegate = self
        documentations = docuHandler.getAllDocumentations()
        documentationList.delegate = self
        documentationList.dataSource = self
        documentationList.allowsSelection = false
        documentationList.reloadData()
        
    }
}
