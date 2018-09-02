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
        cell.Content.text = documentations[indexPath.row].textDocumentation?.content
        print("ID \(cell.ID.text)")
        print("Date \(cell.CreationDate.text)")
        print("Content \(cell.Content.text)")
        return cell
    }
    
    //protocol for delegation
    func updatedMDocumentationList(docuList: [Documentation]) {
        print("DocuVC sollte jetzt eigentlich neue Daten anzeigen...")
        documentations = docuList
        documentationList.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        documentations = docuHandler.getAllDocumentations()
        documentationList.reloadData()
        print("DocuVC sollte jetzt eigentlich \(documentations.count) Daten anzeigen...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docuHandler.delegate = self
        documentations = docuHandler.getAllDocumentations()
        documentationList.delegate = self
        documentationList.dataSource = self
        documentationList.reloadData()
    }
}
