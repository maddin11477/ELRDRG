//
//  MissionImageTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class MissionImageTableViewCell: UITableViewCell {

    private var mission : Mission?
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var lblID: UILabel!
    var storyboard : UIStoryboard?
    var delegate : changedMissionDelegate?
    var viewController : UIViewController?
    @IBAction func editMission(_ sender: Any) {
        if let einsatz = mission
        {
            if let board = storyboard
            {
                let controller = board.instantiateViewController(withIdentifier: "ChangeMissionVC") as! ChangeMissionVC
                controller.delegate = self.delegate
                controller.mission = einsatz
                controller.id = Int(lblID.text ?? "-1") ?? -1
                if let view_controller = viewController
                {
                    view_controller.present(controller, animated: true, completion: nil)
                }
            }
        }

    }
    
    public func load(mission : Mission)
    {
        self.mission = mission
        self.lblID.text = String(mission.getID()!)
        lblMissionName.text = mission.reason
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        lblDate.text = formatter.string(from: mission.start!) + " Uhr"
        if mission.isFinished
        {
            imgState.image = UIImage(systemName: "lock.fill")
            imgState.tintColor = UIColor.systemGreen
            
        }
        else
        {
            imgState.image = UIImage(systemName: "lock.open.fill")
            imgState.tintColor = UIColor.systemGray4
        }
        
        if let img = mission.getThumbnail()
        {
            self.imgContent.image = img
        }
    }
    
    @IBOutlet weak var lblMissionName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgState: UIImageView!
    
    @IBOutlet weak var imgContent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
