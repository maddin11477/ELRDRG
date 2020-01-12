//
//  UnitsCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 10.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class UnitsCVC: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    var units : [Unit] = []
    let dataHandler = DataHandler()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(section == 0)
        {
            return 2
        }
        else if(section < 4)
        {
            return units.filter({
                if let cat = $0.getGlobalCategory()
                {
                    if(cat == section)
                    {
                        return true
                    }
                }
                return false
                
                }).count
        }
        else
        {
            return units.filter({
                if let cat = $0.getGlobalCategory()
                {
                    if(cat > 3)
                    {
                        return true
                    }
                }
                return false
                
                }).count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitsOverViewCVC", for: indexPath) as! UnitsOverViewCVC
			if indexPath.row == 0
			{
				//Freie Rettungsmittel
				cell.update(all: false)
			}
			else
			{
				//Alle Rettungsmittel
				cell.update(all: true)
			}

            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitCVC", for: indexPath) as! UnitCVC
            var _units : [Unit]
            if(indexPath.section < 4)
            {
                _units = units.filter({
                    if let cat = $0.getGlobalCategory()
                {
                    if(cat == indexPath.section)
                    {
                        return true
                    }
                }
                return false
                
                })
            }
            else
            {
                _units = units.filter({
                    if let cat = $0.getGlobalCategory()
                    {
                        if(cat > 3)
                        {
                            return true
                        }
                    }
                    return false
                })
            }
            cell.setup(unit: _units[indexPath.row])
            
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    public func setup()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        loadUnits()
        collectionView.reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    func loadUnits()
    {
        var victims = dataHandler.getVictims()
        victims.sort(by: {$0.category < $1.category})
        units.removeAll()
        //Filtering Units from Victims
        for victim in victims {
            if let _units = victim.fahrzeug?.allObjects as? [Unit]
            {
                self.units += _units
            }
        }
        
        
    }
    @IBOutlet var collectionView: UICollectionView!
}
