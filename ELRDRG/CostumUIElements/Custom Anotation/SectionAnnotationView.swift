//
//  SectionAnnotationView.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.02.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import Foundation
import UIKit

protocol SectionAnnotationViewDelegate {
	func removeSection(section : Section?)

}

@IBDesignable
class SectionAnnotationView : UIView, UITableViewDataSource, UITableViewDelegate
{
	var UnitList : [Unit] = []

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.UnitList = self.section?.units?.allObjects as! [Unit]
		return self.UnitList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnitXIBCustomTableViewCell") as! UnitXIBCustomTableViewCell
		cell.setUnit(unit: UnitList[indexPath.row])
		return cell


	}

	public var delegate : SectionAnnotationViewDelegate?
	private var section : Section?
	@IBOutlet var tableView: UITableView!
	@IBOutlet var lbl_sectionName: UILabel!

	@IBAction func remove(_ sender: Any) {

		if let del = self.delegate
		{
			del.removeSection(section: self.section)
		}
	}

	public func updateSection()
	{
		self.tableView.reloadData()
		self.lbl_sectionName.text = section?.identifier ?? "unknown Section"
	}

	public func setSection(section: Section)
	{
		/*self.tableView.register(UnitXIBCustomTableViewCell.self, forCellReuseIdentifier: "UnitXIBCustomTableViewCell")
		self.section = section
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.lbl_sectionName.text = section.identifier ?? "unknown Section"
		self.tableView.reloadData()*/


	}


}
