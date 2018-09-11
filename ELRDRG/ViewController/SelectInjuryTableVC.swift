//
//  SelectInjuryTableVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

class SelectInjuryTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return injuries.count
    }
   
    
    @IBAction func dismiss_click(_ sender: Any)
    {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "InjuryCell") as! InjuryCostumTableViewCell
        cell.Location.text = injuries[indexPath.row].loaction
        cell.Name.text = injuries[indexPath.row].diagnosis
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let injuryHanlder = InjuryHandler()
        injuries = []
        let injuryList = injuryHanlder.getAllBaseInjury()
        for injurie in injuryList {
            if(injurie.diagnosis!.contains(searchText) || injurie.loaction!.contains(searchText))
            {
                injuries.append(injurie)
            }
        }
        table.reloadData()
        
        
        
    }

    public var message : String = ""
    
    public var bodyPart : InjuryHandler.locations?
    public var bodySide : InjuryHandler.side?
    
    var injuries : [BaseInjury] = []
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var Searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Searchbar.text = InjuryHandler.locationArray[Int(bodyPart!.rawValue)]
        filter()
        table.delegate = self
        table.dataSource = self
        Searchbar.delegate = self
        table.reloadData()
    }
    
    func filter()
    {
         injuries = []
        let injuryHanlder = InjuryHandler()
        let injuryList = injuryHanlder.getAllBaseInjury()
        for injury in injuryList
        {
            if(injury.loaction == InjuryHandler.locationArray[Int(bodyPart!.rawValue)])
            {
                injuries.append(injury)
            }
        }
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
