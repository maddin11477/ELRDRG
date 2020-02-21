//
//  MissionCostumTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 28.08.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class MissionCostumTableViewCell: UITableViewCell {

    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var Reason: UILabel!
    @IBOutlet weak var Date: UILabel!

	@IBOutlet var missionStateImage: UIImageView!
	
	var mission : Mission?
	var storyboard : UIStoryboard?
	var delegate : changedMissionDelegate?
	var viewController : UIViewController?
	@IBAction func changeMission(_ sender: Any) {
		if let einsatz = mission
		{
			if let board = storyboard
			{
				let controller = board.instantiateViewController(withIdentifier: "ChangeMissionVC") as! ChangeMissionVC
				controller.delegate = self.delegate
				controller.mission = einsatz
				if let view_controller = viewController
				{
					view_controller.present(controller, animated: true, completion: nil)
				}
			}
		}

	}


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
