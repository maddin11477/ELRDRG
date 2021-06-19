//
//  ChangeMissionVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.01.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit

protocol changedMissionDelegate {
	func didEndEditingMission()
}

class ChangeMissionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iMissionMetaDataCVC.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.row == 0)
        {

            return CGSize(width: 520, height: 210)
        }
        else if(indexPath.row == 1)
        {
            return CGSize(width: 460, height: 210)
        }
        else if(indexPath.row == 2)
        {
            return CGSize(width: 490, height: 210)
        }
        else
        {
            return CGSize(width: 490, height: 210)
        }
        
        
    }
    
    
    @IBOutlet weak var endMissioncmd: UIButton!
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Abstact Solution:
        
        
        if let cell = iMissionMetaDataCVC.getCell(collectionView: self.collectionView, indexPath: indexPath, mission: self.mission!)
        {
            return cell
        }
        else
        {
            fatalError("cell found nil at indexpath.row = \(indexPath.row)")
        }
        
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
	var mission : Mission?
	var id : Int?

	@IBOutlet var HeaderImage: UIImageView!

    @IBOutlet weak var lblMissionID: UILabel!
    
	public var delegate : changedMissionDelegate?

	@IBAction func EndMission_click(_ sender: Any) {
       if let mission = self.mission
        {
            
            if mission.isFinished
            {
                let alertController = UIAlertController(title: "Einsatz erneut öffnen?", message: "Sicher, dass Sie den Einsatz öffnen möchten?", preferredStyle: .alert)
                let actionController = UIAlertAction(title: "Nein", style: .default, handler: nil)
                let actionController1 = UIAlertAction(title: "Öffnen", style: .destructive, handler: self.openMission)
                alertController.addAction(actionController)
                alertController.addAction(actionController1)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
		let alertController = UIAlertController(title: "Einsatz beenden?", message: "Sicher, dass Sie den Einsatz abschließen möchten? Änderungen können anschließend nicht rückgängig gemacht werden!", preferredStyle: .alert)
		let actionController = UIAlertAction(title: "Nein", style: .default, handler: nil)
		let actionController1 = UIAlertAction(title: "Beenden", style: .destructive, handler: self.endMission)
		alertController.addAction(actionController)
		alertController.addAction(actionController1)
		self.present(alertController, animated: true, completion: nil)
        

	}


	func endMission(sender : Any)
	{
		if let einsatz = self.mission
		{
			self.HeaderImage.image = UIImage(systemName: "lock.fill")
            self.HeaderImage.tintColor = UIColor.systemGreen
            einsatz.endMission()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:mm"
            iMissionMetaDataCVC.refreshAll()
            self.endMissioncmd.setTitle("Einsatz öffnen", for: .normal)
            self.endMissioncmd.backgroundColor = UIColor.blue
		}
	}
    
    func openMission(sender : Any)
    {
        if let mission = self.mission
        {
            self.HeaderImage.image = UIImage(systemName: "lock.open.fill")
            self.HeaderImage.tintColor = UIColor.systemGray
            mission.reOpen()
            iMissionMetaDataCVC.refreshAll()
            self.endMissioncmd.setTitle("Einsatz beenden", for: .normal)
            self.endMissioncmd.backgroundColor = UIColor.red
        }
    }

	@IBAction func deleteMission_click(_ sender: Any) {
		let alertcontroller = UIAlertController(title: "Löschen", message: "Sind Sie sicher, dass Sie diesen Einsatz unwiederruflich löschen möchten?", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: self.deleteMission)
		alertcontroller.addAction(action)
		let abort = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
		alertcontroller.addAction(abort)
		self.present(alertcontroller, animated: true, completion: nil)
	}

	func deleteMission(information : Any)
	{
		if let einsatz = self.mission
		{
			DataHandler().deleteMission(mission: einsatz)
			self.delegate?.didEndEditingMission()
			self.dismiss(animated: true, completion: nil)
		}

	}

	@IBAction func saveMission_click(_ sender: Any) {
		if let _ = self.mission
		{
            iMissionMetaDataCVC.saveAll()
			DataHandler().saveData()
		}
		if let del = self.delegate
		{
			del.didEndEditingMission()
		}
		self.dismiss(animated: true, completion: nil)
	}

	


	
    
   
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.contentOffset = CGPoint(x: 10, y: 10)
        collectionView.reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.collectionViewLayout.invalidateLayout()

		if let einsatz = self.mission
		{
            self.lblMissionID.text = "ID:  \(String(einsatz.getID() ?? -1))"
			if einsatz.isFinished
			{
				self.HeaderImage.image = UIImage(systemName: "lock.fill")
				self.HeaderImage.tintColor = UIColor.systemGreen
                self.endMissioncmd.setTitle("Einsatz öffnen", for: .normal)
                self.endMissioncmd.backgroundColor = UIColor.blue
			}
            else
            {
                self.HeaderImage.image = UIImage(systemName: "lock.open.fill")
                self.HeaderImage.tintColor = UIColor.systemGray
                self.endMissioncmd.setTitle("Einsatz beenden", for: .normal)
                self.endMissioncmd.backgroundColor = UIColor.red
            }
            
		}
       
    }
    



}
