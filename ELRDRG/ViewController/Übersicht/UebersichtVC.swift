//
//  UebersichtVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 28.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class UebersichtVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, presentViewController {

	@IBOutlet var OverViewTitleItem: UINavigationItem!


    func presentController(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell : UICollectionViewCell?
        if(indexPath.row == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PatientCVC", for: indexPath) as! PatientCVC
            cell.setup()
            cell.delegate = self
            return cell
        }
        else if(indexPath.row == 1)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocuCVC", for: indexPath) as! DocuCVC
            cell.setup()
            return cell
        }
        else 
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitsCVC", for: indexPath) as! UnitsCVC
            cell.setup()
            return cell
        }
        
          
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.row == 2)
        {
            let width = UIScreen.main.bounds.width - 10
            return CGSize(width: width, height: 170)
        }
        else if(indexPath.row == 1)
        {
            return CGSize(width: 500, height: 450)
        }
        else
        {
            return CGSize(width: 480, height: 450)
        }
        
        
    }
    
    let login : LoginHandler = LoginHandler()
    let data : DataHandler = DataHandler()
    var victims : [Victim] = []
    @IBOutlet var collectionView: UICollectionView!
  
    
    
    @IBAction func endMission_Click(_ sender: Any)
    {
        data.setEndDate()
        login.setCurrentMissionUnique(unique: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exportMission(_ sender: Any)
    {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
		let mission : Mission = DataHandler().getMissionFromUnique(unique: (login.getLoggedInUser()?.currentMissionUnique)!)!
		self.OverViewTitleItem.title = (mission.reason ?? "Übersicht")
        print("view did appear")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.data = DataHandler()
        self.victims = data.getVictims()
        
       NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        
       
        collectionView.dataSource = self
        collectionView.delegate = self
        //collectionView.collectionViewLayout
        
        collectionView.contentOffset = CGPoint(x: 10, y: 10)
        collectionView.reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.collectionViewLayout.invalidateLayout()
        ProcessBadges() //loads current States to set Badges
        
        
    }
    
    @objc func viewDidBecomeActive() {
        print("viewDidBecomeActive")
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func ProcessBadges()
    {
        
        var countDone : Int = 0
              var countNotDone : Int = 0
              
              for vic in victims {
                  if(vic.isDone == nil)
                  {
                      countNotDone = countNotDone + 1
                  }
                  else
                  {
                      countDone = countDone + 1
                  }
              }
              if let tabItems = tabBarController?.tabBar.items {
                  
                  let tabItem = tabItems[3]
                  if(countNotDone > 0)
                  {
                       tabItem.badgeValue = String(countNotDone)
                       tabItem.badgeColor = UIColor.red
                  }
                  else
                  {
                      tabItem.badgeValue = "Erledigt"
                      tabItem.badgeColor = UIColor.green
                  }
                 
              }
    }

   
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       print("traited")
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        self.view.layoutMarginsDidChange()
    }

  

}
