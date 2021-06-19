//
//  CreateTempObjectViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 25.03.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
protocol OrganisationAddedTempObjectProtocoll {
	func createdUnit()
	func createdSection()
}

class CreateTempObjectViewController: UIViewController, UnitExtention {
   
    func createdUnit(unit: BaseUnit) {
        delegate!.createdUnit()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public var delegate : OrganisationAddedTempObjectProtocoll?
    
    @IBAction func CreateSection(_ sender: Any)
    {
        handleSectionAddAction()
    }
    
    @IBAction func CreateUnit(_ sender: Any)
    {
        handleUnitAddAction()
    }
    
    
    func handleUnitAddAction()
    {
        let AddUnitController = self.storyboard?.instantiateViewController(withIdentifier: "CreateUnitVC") as! CreateUnitVC
        AddUnitController.delegate = self
        AddUnitController.modalPresentationStyle = .popover
        AddUnitController.popoverPresentationController?.barButtonItem = self.popoverPresentationController?.barButtonItem
        self.present(AddUnitController, animated: true, completion: nil)
       
    }
    
    func handleSectionAddAction()
    {
        let alertController = UIAlertController(title: "Einsatzabschnitt", message: "Stammdaten Einsatzabschnitt erstellen", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name Einsatzabschnitt"
        }
        
        let saveAction = UIAlertAction(title: "Erstellen", style: .default, handler: { alert -> Void in
            let sectionIdentifier = (alertController.textFields![0] as UITextField).text
            
            if((alertController.textFields![0] as UITextField).text != "")
            {
				
                let sectionData : SectionHandler = SectionHandler()
				if SettingsHandler().getSettings().safe_new_sections_permanent
				{
					let _ = sectionData.addBaseSection(identifier: sectionIdentifier!)
				}
				if SettingsHandler().getSettings().add_new_sections_to_mission
				{
					sectionData.addSection(identifier: sectionIdentifier!)
				}

                self.delegate!.createdSection()
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
        })
        
        let abortaction = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(abortaction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
