//
//  DocumentationDetailTextVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationDetailTextVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var templates : [DocumentationTemplate] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.templates = DocumentationHandler().getDocumentationTemplates()
        return templates.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentationTemplateTableViewCell") as! DocumentationTemplateTableViewCell
        cell.lbl_Template.text = templates[indexPath.row].content
        return cell
    }
    
    @IBOutlet weak var docuTemplateList: UITableView!
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.TextContent.text = templates[indexPath.row].content
         self.templates[indexPath.row].increment()
         self.docuTemplateList.reloadData()
    }
    
    
    var DocuHandler: DocumentationHandler = DocumentationHandler()
    public var documentation : Documentation?
    @IBOutlet weak var labelCaption: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.docuTemplateList.dataSource = self
        self.docuTemplateList.delegate = self
        self.docuTemplateList.reloadData()
        
        if(documentation != nil)
        {
            TextContent.text = documentation!.content ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyyy"
            let dateString = formatter.string(from: documentation!.created!)
            labelCaption.text = "Eintrag Einsatztagebuch um \(dateString)"
        }
        else{
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            let dateString = formatter.string(from: currentDateTime)
            labelCaption.text = "Eintrag Einsatztagebuch um \(dateString)"
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var TextContent: UITextView!
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        if(documentation != nil)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyyy"
            let dateString = formatter.string(from: Date())
            documentation?.content = TextContent.text + "\r\n\r\n" + "Edited: " + dateString
            DocuHandler.UpdatedDocumentations()
        }
        else{
            DocuHandler.SaveTextDocumentation(textcontent: TextContent.text, savedate: Date())
        }
        
        
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
