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
        //let cell = DocumentationTableViewCell()
        let currentDocumentation : Documentation = documentations[indexPath.row]
        let attachments = currentDocumentation.attachments?.allObjects as! [Attachment]
        var attachment : Attachment
       
        var attachmentType : Int16 = -1
        if(attachments.count > 0)
        {
            attachment = attachments[0]
            attachmentType = attachment.type
           
        }
        
        
        if(attachmentType == DocumentationType.Audio.rawValue)
        {
            let cell = documentationList.dequeueReusableCell(withIdentifier: "DocumentationAudioTableViewCell") as! DocumentationAudioTableViewCell
            cell.idLabel.text = String(documentations[indexPath.row].id)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyyy"
            cell.attchment = (documentations[indexPath.row].attachments?.allObjects as! [Attachment])[0]
            cell.dateLabel.text = formatter.string(from: documentations[indexPath.row].created!)
            //cell.descriptionLabel.text = documentations[indexPath.row].content ?? ""
            if #available(iOS 13.0, *)
            {
                cell.controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                cell.controlButton.setTitle("", for: .normal)
            }
            else
            {
                cell.controlButton.setTitle("PLAY", for: .normal)
            }
            cell.controlButton.imageView?.tintColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            cell.controlButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            cell.controlButton.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            //cell.controlButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            //Spacing
            //Spacing
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.content.text = documentations[indexPath.row].content ?? ""
            if(cell.content.text! == "")
            {
                cell.content.text = "AUDIORECORDING"
                cell.content.textColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            }
            else
            {
                cell.content.textColor = UIColor(named: "Reverse_UIBackcolor")
            }
         
            
            
            
            
           
            
            cell.alreadyLoaded = true
            
            return cell
        }
        else
        {
            
        
        let cell = documentationList.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
        cell.ID.text = String(documentations[indexPath.row].id)
        cell.Content.text = documentations[indexPath.row].content
            
        //Spacing
       
       
        cell.alreadyLoaded = true
        
        
        
        
        
        
        
        //Hier die Anhänge der Doku bearbeiten
        let attachments = documentations[indexPath.row].attachments?.allObjects as! [Attachment]
        print("Anhänge:\(attachments.count)")
        if(attachments.count > 0){
            //Achtung:
            //Aktuell wird nur ein Anhang pro Docueintrag unterstützt
            //1...n muss hier noch implmentiert werden.
            let attachment = attachments[0]
            switch attachment.type {
                case DocumentationType.Photo.rawValue:
                    print("Photo gefunden")
                    if let image = docuHandler.getImage(pictureName: attachment.uniqueName!){
                        cell.Thumbnail.image = image
                        cell.Thumbnail.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
                        cell.Thumbnail.contentMode = UIViewContentMode.scaleAspectFit
                    }
                    else
                    {
                        cell.Thumbnail.image = nil
                    }
                //case DocumentationType.Audio.rawValue:
                   // cell.Thumbnail.image = nil
                default:
                    print("Nur Text")
                    cell.Thumbnail.image = nil
            }
        }
        else
        {
            cell.Thumbnail.image = nil
            }
        
        //wie komm ich an die verlinkten zellen??
        
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Zeile \(indexPath.row) ausgewählt")
        let docuEntry = documentations[indexPath.row]
        let attachments = docuEntry.attachments?.allObjects as! [Attachment]
        if(attachments.count > 0){
            let attachment = attachments[0]
            switch attachment.type {
            case DocumentationType.Photo.rawValue:
                //Foto doku öffnen
                
                print("Photo gefunden")
                let details = storyboard?.instantiateViewController(withIdentifier: "DocumentationDetailPhotoVC") as! DocumentationDetailPhotoVC
                details.documentation = docuEntry
                self.present(details, animated: true, completion: nil)

            case DocumentationType.Audio.rawValue:
                //audio Doku öffnen
                print("Audio gefunden")
                let details = storyboard?.instantiateViewController(withIdentifier: "DocumentationDetailAudioVC") as! DocumentationDetailAudioVC
                details.audioDocumentation = documentations[indexPath.row]
                self.present(details, animated: true, completion: nil)
            default:
                print("Nur Text")
            }
        }
        else {
            let details = storyboard?.instantiateViewController(withIdentifier: "DocumentationDetailTextVC") as! DocumentationDetailTextVC
            details.documentation = documentations[indexPath.row]
            self.present(details, animated: true, completion: nil)
            //nur Text Doku...
            print("Text gefunden")
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            let id: Int = Int(documentations[indexPath.row].id)
            docuHandler.deleteDocuEntry(id: id)
        }
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
        documentationList.reloadData()
        
    }
}
