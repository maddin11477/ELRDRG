//
//  DocuTemplateDetailViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.12.20.
//  Copyright © 2020 Jonas Wehner. All rights reserved.
//

import UIKit

class DocuTemplateDetailViewController: UIViewController, UITextViewDelegate {
    
    var color : UIColor?
    var startText : String = "Vorlage .."
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.startText
        {
            textView.text = ""
            textView.textColor = color
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let text = textView.text?.replacingOccurrences(of: " ", with: "")
        {
            if text == ""
            {
                textView.text = self.startText
                textView.textColor = UIColor.lightGray
            }
        }
        else
        {
            textView.text = self.startText
            textView.textColor = UIColor.lightGray
        }
        return true
        
    }
    
    @IBAction func safe(_ sender : Any)
    {
        //Creates new entry in Database
        let _ = DocumentationHandler().createDocumentaitonTemplate(text: self.lbl_content.text ?? "empty")
        DocumentationHandler().saveData()
        print(self.lbl_content.text ?? "empty")
        DocuTemplatesViewController.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_content.layer.cornerRadius = 5.0
        self.lbl_content.layer.borderWidth = 1.0
        self.lbl_content.layer.borderColor = UIColor.gray.cgColor
        self.lbl_content.delegate = self
        self.lbl_content.text = self.startText
        self.color = self.lbl_content.textColor
        self.lbl_content.textColor = UIColor.lightGray
        if let text = self.lbl_content.text, text == self.startText
        {
            self.lbl_content.text = self.startText
            self.lbl_content.textColor = UIColor.lightGray
        }
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
