//
//  MissionMetaDataCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit
/**
       
 Returns CollectionViewCell due to the indexPath
 
 - Author:
    Jonas Wehner
 
 - returns:
    - CollectionViewCell
 
 
 # List of CollectionViewCells
    * displays each iMissionMetaDataCVC on the MetaDatas View Controller
    * no need to do anything more in Viewcontroller, just add new Instance to **subclasses** : iMissionMetaDataCVC
    * Anything else has to be overwritten in the subclass of iMissionMetaDataCVC
 
 # Subclasses need to override:
    * func load()
    * func save()
    * func getCellIdentifier() -> Return Identifier setup for the CollectionViewCell on the designer
 
 */
class iMissionMetaDataCVC: UICollectionViewCell {
    
    
    
    private static let subclasses : [iMissionMetaDataCVC] = [MissionGeneralInfoCollectionViewCell(), MissionCommanderCVC(), missionCategoryCVC(), MissionDateCVC()]
    
    private static var subclassInstances : [iMissionMetaDataCVC] = []
    
    //return current amount of CollectionViewCells
    public static var cellCount : Int {
        get{
            return subclasses.count
        }
    }
    
    var mission : Mission?
    
    public static func getCell(collectionView : UICollectionView, indexPath : IndexPath, mission : Mission)->iMissionMetaDataCVC?
    {
        return getCollectionViewCell(collectionView: collectionView, indexPath: indexPath, subType: subclasses[indexPath.row], mission: mission)
    }
    
    //current version only support 1 Section
    private static func getCollectionViewCell<T : iMissionMetaDataCVC>(collectionView : UICollectionView, indexPath : IndexPath, subType : T, mission : Mission)->iMissionMetaDataCVC?
    {
        if indexPath.row == 0
        {
            subclassInstances.removeAll()
        }
        // Make Sure indexRow is not bigger than available subclasses (should be safe if cellCount is used un numberOfItemsInSection
        if indexPath.row > subclasses.count
        {
            return nil
        }
        
        // Create CollectionViewCell of Type T : iMissionMetaDataCVC relative to the collectionView from HMI
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subType.getCellIdentifier(), for: indexPath) as! T
        cell.load(object: mission)
        
        subclassInstances.append(cell)
        
        return cell
    }
    
    public static func refreshAll()
    {
        for instance in subclassInstances {
            instance.load()
        }
    }
    
    func className() -> String {
            return String(describing:type(of:self))
    }
    
    func getCellIdentifier()->String
    {
        fatalError("derived \(className()) class needs to implement getCellIdentifier method!")
    }
    
    public func setMission(mission : Mission)
    {
        self.mission = mission
    }
    
    public static func saveAll()
    {
        for instance in subclassInstances {
            instance.save()
        }
        DataHandler().saveData()
    }
    
    public func save(object : AnyObject? = nil)
    {
        
    }
    
    public func load(object : AnyObject? = nil)
    {
        if let mission = object as? Mission
        {
            self.mission = mission
            
        }
        
        if let mission = self.mission
        {
            if mission.isFinished
            {
                self.isUserInteractionEnabled = false
            }
            else
            {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    
}
