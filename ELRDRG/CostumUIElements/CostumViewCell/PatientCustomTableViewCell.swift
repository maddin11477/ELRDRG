//
//  PatientCustomTableViewCell.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
protocol PatientTableViewLongPressRecognized {
    func started(victimController : UIViewController)
    func stop()
}


class PatientCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ID: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var birthDate: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var hospital: UILabel!
    
    @IBOutlet weak var unit: UILabel!
    
    @IBOutlet weak var child: UILabel!
    
    @IBOutlet weak var sht: UILabel!
    
    @IBOutlet weak var heatinjury: UILabel!
    
    @IBOutlet weak var helicopter: UILabel!
    @IBOutlet var hospitalInfoStateColorElement: UILabel!
    
    public var delegate : PatientTableViewLongPressRecognized?
    public var alreadyLoaded : Bool = false
    public var background_View : UIView = UIView()
    //public var victimList : [Victim] = []
    public var victim : Victim?
    
    @IBOutlet var lblHospitalInfoState: UILabel!
    
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.3 // 1 second press
        longPressGesture.delegate = self
        self.contentView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {

                if let vic = victim
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                    let patientController = storyBoard.instantiateViewController(withIdentifier: "PatientPopOverVC") as! PatientPopOverVC
                   
                    patientController.patient = vic
                    //patientController.popoverPresentationController?.sourceView = self.contentView
					patientController.modalPresentationStyle = .formSheet
                    patientController.popoverPresentationController?.sourceView = self.contentView
					
                    self.delegate?.started(victimController: patientController)
                }
            
        }
        else if longPressGestureRecognizer.state == UIGestureRecognizerState.ended
        {
            self.delegate?.stop()
        }
        
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutMargins.left = 10
        layoutMargins.top = 10
        layoutMarginsDidChange()
        setupLongPressGesture()
        lblHospitalInfoState.text = victim?.getHospitalInfoState()
        hospitalInfoStateColorElement.backgroundColor = victim?.getHospitalInfoState()
        
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
