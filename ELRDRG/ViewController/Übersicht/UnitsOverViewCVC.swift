//
//  UnitsOverViewCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 13.12.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class UnitsOverViewCVC: UICollectionViewCell {
    
    @IBOutlet var lbl_RTW: UILabel!
    
    @IBOutlet var lbl_Na: UILabel!
    
    @IBOutlet var lbl_ktw: UILabel!
    
    @IBOutlet var lbl_rth: UILabel!
    
    @IBOutlet var lbl_sonst: UILabel!
    
	@IBOutlet var headline: UILabel!

	public func update(all : Bool)
    {
		let unitHandler = UnitHandler()



        if(all)
		{
			self.headline.text = "Alle Rettungsmittel"
			let rtw = unitHandler.getUsedUnits(UnitType: .RTW).count
			let na = unitHandler.getUsedUnits(UnitType: .NEF).count
			let ktw = unitHandler.getUsedUnits(UnitType: .KTW).count
			let rth = unitHandler.getUsedUnits(UnitType: .RTH).count
			let sonst = unitHandler.getUsedUnits().count - rtw - na - ktw - rth
			lbl_RTW.text = "x " + String(rtw)
			lbl_Na.text = "x " + String(na)
			lbl_ktw.text = "x " + String(ktw)
			lbl_rth.text = "x " + String(rth)
			lbl_sonst.text = "x " + String(sonst)
		}
		else
		{
			self.headline.text = "Freie Rettungsmittel"
			let rtw = unitHandler.getFreeUsedUnits(UnitType: .RTW).count
			let na = unitHandler.getFreeUsedUnits(UnitType: .NEF).count
			let ktw = unitHandler.getFreeUsedUnits(UnitType: .KTW).count
			let rth = unitHandler.getFreeUsedUnits(UnitType: .RTH).count
			let sonst = unitHandler.getFreeUsedUnits().count - rtw - na - ktw - rth

			lbl_RTW.text = "x " + String(rtw)
			lbl_Na.text = "x " + String(na)
			lbl_ktw.text = "x " + String(ktw)
			lbl_rth.text = "x " + String(rth)
			lbl_sonst.text = "x " + String(sonst)
		}

        
    }
    
}
