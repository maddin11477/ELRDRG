//
//  SelectInjuryTableVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol InjurySelectionProtocol {
    func selectedInjury(injury : Injury)
}

class SelectInjuryTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(search_Text != "")
        {
            return injuries.count + 1
        }
        else{
            return injuries.count
        }
        
    }
    public var text : String = ""
    public var search_Text : String = ""
    public var delegate : InjurySelectionProtocol?
   
    
    @IBAction func dismiss_click(_ sender: Any)
    {
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = table.dequeueReusableCell(withIdentifier: "InjuryCell") as! InjuryCostumTableViewCell
        
        if(indexPath.row == 0)
        {
            cell.Location.text = "  **"
            cell.Name.text = search_Text
        }
        else
        {
            cell.Location.text = injuries[indexPath.row-1].loaction
            cell.Name.text = injuries[indexPath.row-1].diagnosis
        }
       
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       if(self.delegate != nil)
       {
        var row : Int = -1
        if(search_Text != "")
        {
            row = indexPath.row - 1
            
        }
        else
        {
            row = indexPath.row - 1
        }
        
        let injury : Injury
        
        if(search_Text != "" && indexPath.row == 0)
        {
            injury = Injury(context: AppDelegate.viewContext)
            injury.diagnosis = search_Text
            injury.location = ""
            
            
        }
        else
        {
           
            let injurydata = InjuryHandler()
            
            injury = injurydata.convertToInjury(baseInjury: injuries[row])
            injury.location = injury.location! + " " + injurydata.sideToString(side: bodySide)
        }
        
        
        
        
        
        
        self.delegate!.selectedInjury(injury: injury)
        
        
        self.tabBarController!.dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search_Text = searchText
        let injuryHanlder = InjuryHandler()
        injuries = []
        let injuryList = injuryHanlder.getAllBaseInjury()
        if(searchText.count < 1)
        {
            injuries = injuryList
        }
        
        for injurie in injuryList {
            if(injurie.diagnosis!.uppercased().contains(searchText.uppercased()) || injurie.loaction!.uppercased().contains(searchText.uppercased()))
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        print("Bodypart")
        print(text)
        if let part = bodyPart
        {
            Searchbar.text = InjuryHandler.locationArray[Int(part.rawValue)]
            
        }
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
        if let part = bodyPart
        {
            for injury in injuryList
            {
                if(injury.loaction == InjuryHandler.locationArray[Int(part.rawValue)])
                {
                    injuries.append(injury)
                }
            }
        }
        else
        {
            injuries = injuryList
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
