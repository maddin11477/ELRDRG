//
//  DocumentationDetailPhotoVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 06.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class DocumentationDetailPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let docuHandler: DocumentationHandler = DocumentationHandler()
    public var documentation : Documentation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(documentation != nil){
            print("Debug: \(String(describing: documentation!.content))")
            descriptionTextField.text = documentation!.content ?? ""
            for attachment in documentation!.attachments?.allObjects as! [Attachment]
            {
            switch attachment.type {
            case DocumentationType.Photo.rawValue:
                print("Photo gefunden")
                if let image = docuHandler.getImage(pictureName: attachment.uniqueName!){
                    imageView.image = image
                    
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
                }
                else
                {
                    imageView.image = nil
                }
                //case DocumentationType.Audio.rawValue:
            // cell.Thumbnail.image = nil
            default:
                print("Nur Text")
                
            
            }
        
            }
        
        
        
        
        
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        //close UI without any action
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //close UI but save data before
        if(documentation != nil)
        {
         //documentation!.removeFromAttachments((documentation?.attachments?.allObjects as! [Attachment])[0])
         docuHandler.updatePhotoDocumentation(docu: documentation!, text: descriptionTextField.text, picture: imageView.image!)
         
        }
        else
        {
           
            docuHandler.SavePhotoDocumentation(picture: imageView.image!, description: descriptionTextField.text!, saveDate: Date())
            print("Picture saved")
        }
        
        //close ui
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var takePhotoButton: UIButton!

    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(sender.currentTitle==""){
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
            }
        }
        else
        {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)){
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!

            }
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Bildauswahl verarbeiten
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
        print("Cancel photo picking...")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let _ = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //photo
            self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
            self.imageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
			if picker.sourceType == .camera
			{
				UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
			}

            self.dismiss(animated: true, completion: nil)
        }

    }

	//MARK: - Add image to Library
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			// we got back an error!
			showAlertWith(title: "Save error", message: error.localizedDescription)
		} else {
			//showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
		}
	}

	func showAlertWith(title: String, message: String){
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
    


}
