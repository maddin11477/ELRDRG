//
//  DocuTemplatesViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import UIKit

class DocuTemplatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var docuTemplates : [DocumentationTemplate] = []
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    public static var controller : DocuTemplatesViewController?
    public static func reload()
    {
        if let c = controller
        {
            c.reload()
        }
    }
    
    public func reload()
    {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            self.docuTemplates = DocumentationHandler().getDocumentationTemplates()
            return docuTemplates.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocuTemplateTableViewCell") as! DocuTemplateTableViewCell
        cell.set(template: docuTemplates[indexPath.row])
        print(docuTemplates[indexPath.row].content)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        DocuTemplatesViewController.controller = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                    DocumentationHandler().deleteTemplateDocumentationTemplate(template: docuTemplates[indexPath.row])
                    DocumentationHandler().saveData()
                    self.tableView.reloadData()
                }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func addTemplate(_ sender: Any) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
