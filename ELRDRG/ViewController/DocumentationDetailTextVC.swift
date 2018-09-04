//
//  DocumentationDetailTextVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationDetailTextVC: UIViewController {

    var DocuHandler: DocumentationHandler = DocumentationHandler()
    
    @IBOutlet weak var labelCaption: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = formatter.string(from: currentDateTime)
        labelCaption.text = "Eintrag Einsatztagebuch um \(dateString)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var TextContent: UITextView!
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        DocuHandler.SaveTextDocumentation(textcontent: TextContent.text, savedate: Date())
        
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
