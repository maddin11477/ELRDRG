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
        docuHandler.SavePhotoDocumentation(picture: imageView.image!, description: descriptionTextField.text!, saveDate: Date())
        print("Picture saved")
        //close ui
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var takePhotoButton: UIButton!

    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(sender.currentTitle=="Cam"){
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
        if let mediaType = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //photo
            self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }

    }
    


}
