//
//  MissionImageTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.06.21.
//  Copyright © 2021 Jonas Wehner. All rights reserved.
//

import UIKit

class MissionImageTableViewCell: ShadowViewCell {

    private var mission : Mission?
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var lblMissionType: UILabel!
    @IBOutlet weak var lblID: UILabel!
    var storyboard : UIStoryboard?
    var delegate : changedMissionDelegate?
    var viewController : UIViewController?
    
    @IBOutlet weak var lblMissionMaster: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        
        
        //contentView.frame = contentView.frame.UIEdgeInsetsInsetRect(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        //contentView.frame = self.frame.insetBy(dx: 10.0, dy: 10.0)
    }
    
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
        if let einsatz = self.mission, let user = einsatz.user
        {
            self.lblMissionMaster.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
        }
        
        self.lblID.text = String(mission.getID()!)
        lblMissionName.text = mission.reason
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        lblMissionType.text = self.mission?.missionType
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

class ShadowViewCell: UITableViewCell {

    var setupShadowDone: Bool = false
    
    
    
    
    
    public func setupShadow() {
        if setupShadowDone { return }
        print("Setup shadow!")
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height:
8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    
        setupShadowDone = true
    }

    
}
