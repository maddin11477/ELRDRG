//
//  UnitXIBCustomTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.02.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UnitXIBCustomTableViewCell : UITableViewCell
{
	private var unit : Unit?
	@IBOutlet var typeImage: UIImageView!
	let handler = UnitHandler()
	@IBOutlet var lbl_callSign: UILabel!

	public func setUnit(unit : Unit)
	{
		self.unit = unit

		typeImage.image = UIImage(named: handler.BaseUnit_To_UnitTypeString(id: unit.type))
		lbl_callSign.text = unit.callsign
	}

}
