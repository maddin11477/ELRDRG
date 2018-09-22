//
//  SelectInjuryVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol HumanBodyProtocol {
    
    func didSelectBodyPart( bodyPart : InjuryHandler.locations)
    func didSelectBodyPartWithSideOption( bodyPart : InjuryHandler.locations, side : InjuryHandler.side)
}

class SelectInjuryVC: UIViewController {
    public var delegate : HumanBodyProtocol?
    
    @IBAction func head_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPart(bodyPart: .Kopf)
        }
       // let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectInjuryTableVC") as! SelectInjuryTableVC
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Kopf
        self.tabBarController?.selectedIndex = 1
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func dismiss_click(_ sender: Any)
    {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftHand_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Hand, side: .left)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Hand
        vc.bodySide = .left
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func rightHand_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Hand, side: .right)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Hand
        vc.bodySide = .right
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func rightArm_click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Arm, side: .right)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Arm
        vc.bodySide = .right
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func thorax_click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPart(bodyPart: .Thorax)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Thorax
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func Abdomen_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPart(bodyPart: .Abdomen)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Abdomen
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func leftArm_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Arm, side: .left)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Arm
        vc.bodySide = .left
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func leftLeg_click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Oberschenkel, side: .left)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Oberschenkel
        vc.bodySide = .left
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func rightLeg_click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Oberschenkel, side: .right)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
       // vc.message = "Kopf"
        vc.bodyPart = .Oberschenkel
        vc.bodySide = .right
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func unterschenkelRechts_click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Unterschenkel, side: .right)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Unterschenkel
        vc.bodySide = .right
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func unterschenkelLinks_Click(_ sender: Any)
    {
        if let del = self.delegate
        {
            del.didSelectBodyPartWithSideOption(bodyPart: .Unterschenkel, side: .right)
        }
        let vc = self.tabBarController!.viewControllers![1] as! SelectInjuryTableVC
        //vc.message = "Kopf"
        vc.bodyPart = .Unterschenkel
        vc.bodySide = .left
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
