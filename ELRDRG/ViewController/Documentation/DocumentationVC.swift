//
//  DocumentationVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit



class DocumentationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DocumentationProtocol {
    

    enum DocuItemType {
        case text
        case audio
    }
    public var type : DocuItemType = DocuItemType.text
    
    var audioDocu : [AudioDocumentation] = []
    var textDocu : [TextDocumentation] = []
    var pictureDocu : [PictureDocumentation] = []
    
    var documentations : [Documentation] = []
    var docuHandler = DocumentationHandler()
    
    @IBOutlet weak var documentationList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(type == .text)
//        {
//            return textDocu.count
//        }
//        else if(type == .audio)
//        {
//            return audioDocu.count
//        }
//        else
//        {
//            return pictureDocu.count
//        }
        
        return documentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        
        let row = indexPath.row
        
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell
                if let image = docuHandler.getImage(pictureName: attachment.uniqueName!){
                    cell.ID.text = String(documentations[indexPath.row].id)
                    cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
                    cell.Content.text = documentations[indexPath.row].content
                    cell.Thumbnail.image = image
                    cell.Thumbnail.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
                    cell.Thumbnail.contentMode = UIViewContentMode.scaleAspectFit
                }
                return cell
                
            case DocumentationType.Audio.rawValue:
                print("Audio gefunden")
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentationAudioTableViewCell") as! DocumentationAudioTableViewCell
                cell.idLabel.text = String(documentations[indexPath.row].id)
                cell.dateLabel.text = formatter.string(from: documentations[indexPath.row].created!)
                return cell

            default:
                print("Nur Text")
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell
                cell.ID.text = String(documentations[indexPath.row].id)
                cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
                cell.Content.text = documentations[indexPath.row].content
                cell.Thumbnail.image = nil
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell
            cell.ID.text = String(documentations[indexPath.row].id)
            cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
            cell.Content.text = documentations[indexPath.row].content
            cell.Thumbnail.image = nil
            return cell
        }
        
        
        
        //let cell = DocumentationTableViewCell()
//        let cell = documentationList.dequeueReusableCell(withIdentifier: "DocumentationTableViewCell") as! DocumentationTableViewCell

//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm dd.MM.yyyy"
//        cell.CreationDate.text = formatter.string(from: documentations[indexPath.row].created!)
//        cell.ID.text = String(documentations[indexPath.row].id)
//        cell.Content.text = documentations[indexPath.row].content
        
        //Hier die Anhänge der Doku bearbeiten
//        let attachments = documentations[indexPath.row].attachments?.allObjects as! [Attachment]
//        print("Anhänge:\(attachments.count)")
//        if(attachments.count > 0){
//            //Achtung:
//            //Aktuell wird nur ein Anhang pro Docueintrag unterstützt
//            //1...n muss hier noch implmentiert werden.
//            let attachment = attachments[0]
//            switch attachment.type {
//                case DocumentationType.Photo.rawValue:
//                    print("Photo gefunden")
//                    if let image = docuHandler.getImage(pictureName: attachment.uniqueName!){
//                        cell.Thumbnail.image = image
//                        cell.Thumbnail.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
//                        cell.Thumbnail.contentMode = UIViewContentMode.scaleAspectFit
//                    }
//                case DocumentationType.Audio.rawValue:
//                    cell.Thumbnail.image = nil
//                default:
//                    print("Nur Text")
//            }
//        }
        
        //wie komm ich an die verlinkten zellen??
        
        
//        return cell
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
