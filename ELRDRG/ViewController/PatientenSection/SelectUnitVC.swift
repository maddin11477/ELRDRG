//
//  SelectUnitVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 09.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit

protocol unitSelectedProtocol {
    func didSelectUnit(unit : BaseUnit)
    func didSelectHospital(hospital : BaseHospital)
	func didselectUsedUnit(unit : Unit)
}

class SelectUnitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UnitExtention, UISearchBarDelegate {
    func createdUnit(unit: BaseUnit) {
        self.delegate?.didSelectUnit(unit: unit)
        self.dismiss(animated: true, completion: nil)
    }
    
    let hospitalData = HospitalHandler()
     let unitData = UnitHandler()
    var units : [BaseUnit] = []
	var usedUnits : [Unit] = []

    var hospitals : [BaseHospital] = []
    public var delegate : unitSelectedProtocol?
    public var type : availableTypes = .unitselector
    private var searchText : String = ""
    enum availableTypes {
        case unitselector
        case hospitalselector
    }
    
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
       

        table.reloadData()
    }

	func numberOfSections(in tableView: UITableView) -> Int {
		if type == .unitselector
		{
			return 2
		}
		else {
			return 1
		}

	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //do something
       // used hospitals separieren

		if(type == .unitselector)
		{
			if section == 0
			{

					self.usedUnits = unitData.getUsedUnits()
					usedUnits = usedUnits.filter {
						if typeSelector.selectedSegmentIndex < 4 && $0.type == typeSelector.selectedSegmentIndex
						{
							if searchText.count > 0
							{
								return $0.callsign!.uppercased().contains(searchText.uppercased());
							}
							else
							{
								return true
							}
						}
						else if(typeSelector.selectedSegmentIndex == 4 && $0.type > 3)
						{
							if searchText.count > 0
							{
								return $0.callsign!.uppercased().contains(searchText.uppercased());
							}
							else
							{
								return true
							}
						}
						else
						{
							return false
						}
					}

				usedUnits.sort { ($0.callsign ?? "") < ($1.callsign ?? "") }
				return usedUnits.count
			}

			else
			{
				units = unitData.getUnusedBaseUnits()
				units = units.filter {
					if typeSelector.selectedSegmentIndex < 4 && $0.type == typeSelector.selectedSegmentIndex
					{
						return true
					}
					else if(typeSelector.selectedSegmentIndex == 4 && $0.type > 3)
					{
						return true
					}
					else
					{
						return false
					}
				}
				var newUnitList : [BaseUnit] = []
				if searchText.count > 0
				{
					for unit in self.units
					{
						if(unit.funkrufName!.uppercased().contains(searchText.uppercased()))
						{
							newUnitList.append(unit)
						}
					}
					units = newUnitList
					units.sort { ($0.funkrufName ?? "") < ($1.funkrufName ?? "") }

				}
				newUnitList = []
				for unit in units{
					var available = false
					for usedUnit in usedUnits
					{
						if usedUnit.callsign == unit.funkrufName
						{
							available = true
						}
					}
					if !available
					{
						newUnitList.append(unit)
					}
				}
				units = newUnitList
				units.sort { ($0.funkrufName ?? "") < ($1.funkrufName ?? "") }
				return units.count
			}




		}
		else if(type == .hospitalselector)
		{
			hospitals = hospitalData.getAllHospitals()
			var newHospitalList : [BaseHospital] = []
			if searchText.count > 0
			{
				for hospital in hospitals
				{
					let text : String = (hospital.city ?? "") + " " + (hospital.name ?? "")
					if(text.uppercased().contains(searchText.uppercased()))
					{
						newHospitalList.append(hospital)
					}
				}
				hospitals = newHospitalList
			}
			return hospitals.count
		}
		//einfang
		return 0
        
    }
    @IBAction func AddCostum(_ sender: Any)
    {
        if(type == .unitselector)
        {
           
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateUnitVC") as! CreateUnitVC
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
           
        }
        else
        {
            handleHospitalAddAction()
        }
    }
    
    func handleHospitalAddAction()
    {
        let alertController = UIAlertController(title: "Klinik", message: "Stammdaten Krankenhaus erstellen", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Krankenhaus"
        }
        alertController.addTextField {(textField : UITextField!) -> Void in
            textField.placeholder = "Stadt"
        }
        let saveAction = UIAlertAction(title: "Erstellen", style: .default, handler: { alert -> Void in
            let hospitalName = (alertController.textFields![0] as UITextField).text
            let hospitalCity = (alertController.textFields![1] as UITextField).text
            if((alertController.textFields![0] as UITextField).text != "" && (alertController.textFields![1] as UITextField).text != "")
            {
               
                let hospital = self.hospitalData.addBaseHospital(name: hospitalName!, city: hospitalCity!)
                self.delegate!.didSelectHospital(hospital: hospital)
                self.dismiss(animated: true, completion: nil)
            
                
            }
            
            
        })
        
        let abortaction = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(abortaction)
        self.present(alertController, animated: true, completion: nil)
    }

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if type == .unitselector
		{
			if section == 0
			{
				return "Bereits im Einsatz"
			}
			else{
				return "Stammdaten"
			}
		}
		return ""
	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "selectUnitCell") as! UnitSelectCostumTableViewCell
        if(type == .unitselector)
        {

			if indexPath.section == 0
			{
				let unit = usedUnits[indexPath.row]
				cell.Callsign.text = unit.callsign
				cell.crewCount.text = ""
				cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
				cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
				cell.backgroundColor = UIColor(hue: 0.2917, saturation: 0.35, brightness: 0.92, alpha: 1.0)
			}
			else
			{
				let unit = units[indexPath.row]
				cell.Callsign.text = unit.funkrufName

				cell.crewCount.text = ""

				cell.pictureBox.image = UIImage(named: unitData.BaseUnit_To_UnitTypeString(id: unit.type))
				cell.type.text = unitData.BaseUnit_To_UnitTypeString(id: unit.type)
				cell.backgroundColor = UIColor.white
			}

        }
        else
        {
            let hospital = hospitals[indexPath.row]
            cell.Callsign.text = hospital.name
            cell.type.text = hospital.city
			cell.crewCount.text = String(Int((hospital.distance / 1000).rounded())) + " km"
            cell.pictureBox.image = UIImage(named: "hospital.png")
			cell.backgroundColor = UIColor.white
        }
        //do something
     
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0
		{
			if(type == .unitselector)
			{
				self.delegate!.didselectUsedUnit(unit: usedUnits[indexPath.row])
			}
			else
			{
				self.delegate!.didSelectHospital(hospital: hospitals[indexPath.row])
			}
		}
		else
		{
			if(type == .unitselector)
			{
				self.delegate!.didSelectUnit(unit: units[indexPath.row])
			}
			else
			{
				self.delegate!.didSelectHospital(hospital: hospitals[indexPath.row])
			}
		}

        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func abort_click(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

	@IBOutlet var typeSelector: UISegmentedControl!

	@IBAction func typeSelectorChanged(_ sender: Any) {
		searchBar(self.searchBar, textDidChange: self.searchBar.searchTextField.text ?? "")
	}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        units = unitData.getAllBaseUnits()
		hospitals  = hospitalData.getAllHospitals()
		if self.type == .unitselector
		{
			typeSelector.isHidden = false
		}
		else
		{
			typeSelector.isHidden = true
		}
        searchBar.delegate = self
        
        table.delegate = self
        table.dataSource = self
		searchBar(self.searchBar, textDidChange: self.searchBar.searchTextField.text ?? "")

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
