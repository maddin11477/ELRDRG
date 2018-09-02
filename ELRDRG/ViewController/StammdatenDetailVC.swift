//
//  StammdatenDetailVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 02.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class StammdatenDetailVC: UIViewController , StammdatenDetailVCDelegate{
    func createdHospital(hospital: BaseHospital) {
        //dosomething
        print(String(hospital.name!))
    }
    
    func createdUnit(unit: BaseUnit) {
        //dosomething
        print(String(unit.funkrufName!))
    }
    
    func createdUser(user: User) {
        print(String(user.callsign!))
    }
    
    func createdDiagnose(diagnose: BaseInjury) {
        print(String(diagnose.diagnosis!))
    }
    
    @IBOutlet weak var NavBar: UINavigationBar!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    
    let data : DataHandler = DataHandler()
    public var type : DataHandler.StammdatenTyp = DataHandler.StammdatenTyp.Diagnosen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(type == .Diagnosen)
        {
            navBarItem.title = "Diagnosen"
        }
        else if(type == .Fahrzeuge)
        {
            navBarItem.title = "Fahrzeuge"
        }
        else if(type == .Kliniken)
        {
            navBarItem.title = "Kliniken"
        }
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func add_click(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateUnitVC") as! CreateUnitVC
        self.present(vc, animated: true, completion: nil)
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
