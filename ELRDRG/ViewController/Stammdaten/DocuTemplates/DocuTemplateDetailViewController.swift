//
//  DocuTemplateDetailViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import UIKit

class DocuTemplateDetailViewController: UIViewController {
    
    @IBAction func safe(_ sender : Any)
    {
        
        let docuTemplate = DocumentationHandler().createDocumentaitonTemplate(text: self.lbl_content.text ?? "empty")
        DocumentationHandler().saveData()
        print(self.lbl_content.text ?? "empty")
        DocuTemplatesViewController.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lbl_content: UITextView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
