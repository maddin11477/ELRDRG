//
//  AbschnittCVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 22.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
protocol SectionDropProtocol {
    func dropedUnitInSection()
    func droppedPatientInUnit()
	func dropFailed(controller : UIAlertController)
}
class AbschnittCVC: UICollectionViewCell,UITableViewDataSource, UITableViewDelegate, UITableViewDropDelegate, UITableViewDragDelegate, UnitSectionDelegate, VictimDropDelegate, UIDropInteractionDelegate, changedUnitDelegate {
   
    func reloadTable() {
        table.reloadData()
		self.dropDelegate.dropedUnitInSection()
		self.dropDelegate.droppedPatientInUnit()
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    func costumEnableDropping(on view : UIView, DropInteractionDelegate: UIDropInteractionDelegate)
    {
        let dropInteraction = UIDropInteraction(delegate: DropInteractionDelegate)
        view.addInteraction(dropInteraction)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView = UIEdgeInsetsMake(10, 10, 10, 10)
        costumEnableDropping(on: self.contentView, DropInteractionDelegate: self)
        
    }
    func droppedVictim() {
        table.reloadData()
		self.dropDelegate.dropedUnitInSection()
		
        self.dropDelegate!.droppedPatientInUnit()
    }
    
    func handeledPatientDragDropAction() {
        table.reloadData()
    }


    
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexpath : IndexPath) -> [UIDragItem]
    {
		if indexpath.section == 0
		{
			let string = NSAttributedString(string: String((section_?.victims?.allObjects as! [Victim])[indexpath.row].id))
			let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
			let victim = (section_?.victims?.allObjects as! [Victim])[indexpath.row]
			dragItem.localObject = victim
			return [dragItem]

		}
		else if indexpath.section == 1
		{
			let string = NSAttributedString(string: "Unit")
        
			   let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
				let car  = section_?.getUnits()[indexpath.row]
                    dragItem.localObject = car

                return [dragItem]
            
		}
		else if indexpath.section == 2
		{
			let string = NSAttributedString(string: "Pattern")
			let pattern = self.section_!.getPatterns()[indexpath.row]
			let dragItem = UIDragItem(itemProvider: NSItemProvider(object: string))
			dragItem.localObject = pattern
			return [dragItem]
		}
		else
		{
			return []
		}
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    
    
    var anzahlRTW = 0
    var anzahlKTW = 0
    var anzahlRTH = 0
    var anzahlNEF = 0
    var anzahlSonstige = 0
    
    
    @IBAction func deleteSection_Click(_ sender: Any)
    {
        let lecdata = SectionHandler()
        for car in section_?.units?.allObjects as! [Unit] {
            car.section = nil
        }
        lecdata.deleteSection(sec: section_!)
        
        self.dropDelegate.dropedUnitInSection()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        for item in coordinator.items
        {
           
                if let unit = item.dragItem.localObject as? Unit
                {
                    
                    section_?.addToUnits(unit)
                    unit.section = section_
                    let secData = SectionHandler()
                    secData.saveData()
                    self.dropDelegate.dropedUnitInSection()
                    table.reloadData()
                }
				else if let pat = item.dragItem.localObject as? Victim
				{
					if let anzahl = pat.fahrzeug?.allObjects.count
					{
						if anzahl < 1
						{
							section_?.addToVictims(pat)
							pat.section = section_
							SectionHandler().saveData()
							self.dropDelegate.dropedUnitInSection()
							table.reloadData()
						}
						else
						{
							let alertController = UIAlertController(title: "Nicht möglich", message: "Der Patient \(String(pat.id)) ist bereits Fahrzeug(en) zugeordnet. Fügen Sie das Fahrzeug dem Abschnitt hinzu.", preferredStyle: .alert)
							let alertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
							alertController.addAction(alertAction)
							self.dropDelegate.dropFailed(controller: alertController)

						}
					}


				}
				else if let pat = item.dragItem.localObject as? UnitPattern
				{
					section_?.droppedPattern(pattern: pat)

					self.dropDelegate.dropedUnitInSection()
					table.reloadData()
				}
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        if let _ = session.items[0].localObject as? Unit
        {
            return true
           
        }
		else if let _ = session.items[0].localObject as? Victim
		{
			return true
		}
		else if let _ = session.items[0].localObject as? UnitPattern
		{
			return true
		}
        else
		{
            return false
        }
       
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let _ = session.items[0].localObject as? Unit
        {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
           
        }
		if let _ = session.items[0].localObject as? Victim
		{
			return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
		}
		if let _ = session.items[0].localObject as? UnitPattern
		{
			return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
		}
        else {
            return UITableViewDropProposal(operation: .move, intent: .automatic)
            
        }
        
    }
	


	func numberOfSections(in tableView: UITableView) -> Int {


		return 3
	}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {




		//einfach die Patienten anzeigen die kein fahrzeug zugeordnet wurden
		if section == 0
		{
			//Fill counter display
			lblRTW.text = "RTW: " + String(self.section_?.getUnitbyType(type: .RTW).count ?? 0)
			lblKTW.text = "KTW: " + String(self.section_?.getUnitbyType(type: .KTW).count ?? 0)
			lblNEF.text = "NEF: " + String(self.section_?.getUnitbyType(type: .NEF).count ?? 0)
			lblRTH.text = "RTH: " + String(self.section_?.getUnitbyType(type: .RTH).count ?? 0)

			//Design SETUP
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOffset = CGSize.zero
			self.layer.shadowRadius = 10

			//Victims
			self.victims = self.section_!.getVictims()
			return self.victims!.count

		}
		else if(section == 1)
		{
			//Units
			self.units = self.section_!.getUnits()
			return self.units!.count
		}
		else
		{
			//Unit Patterns
			self.patterns = self.section_!.getPatterns()
			return self.patterns!.count
		}

    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {

		// ------ DELETE -------------------------------------
		case .delete:


			switch indexPath.section {


			// **** VICTIM ****
			case 0:
				if let victim = section_?.getVictims()[indexPath.row]
				{
					victim.section = nil
					section_!.removeFromVictims(victim)
				}
				break


			// **** UNIT *****
			case 1:
				if let unit = section_?.getUnits()[indexPath.row]
				{
					unit.section = nil
					section_!.removeFromUnits(unit)
				}
				break


			// **** PATTERN ****
			case 2:
				if let pattern = section_?.getPatterns()[indexPath.row]
				{
					for unit in pattern.units
					{
						unit.section = nil
						section_!.removeFromUnits(unit)
					}
					pattern.victim.section = nil
				}
				break
			default:
				break
			}
			break;


		// ------- INSERT ------------------------------------
		case .insert:
			break;
		default:
			break;
		}

		// -------- SAVING CHANGES ---------
		let handler = SectionHandler()
		handler.saveData()
		table.reloadData()
		self.dropDelegate.dropedUnitInSection()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		if indexPath.section == 0
		{
			return [] // no action because section 0 = Victims section (victims have own remove button)
		}
        let unit = (self.section_!.units!.allObjects as! [Unit]).sorted(by: { $0.callsign!.lowercased() < $1.callsign!.lowercased() })[indexPath.row]
        var actions : [UITableViewRowAction] = []
        let delete = UITableViewRowAction(style: .destructive, title: "Fzg entfernen") { (action, indexPath) in
           // let unit_ = (self.section_!.units!.allObjects as! [Unit]).sorted(by: { $0.callsign!.lowercased() < $1.callsign!.lowercased() })[indexPath.row]





			switch indexPath.section {


			// **** VICTIM ****
			case 0:
				if let victim = self.section_?.getVictims()[indexPath.row]
				{
					victim.section = nil
					self.section_!.removeFromVictims(victim)
				}
				break


			// **** UNIT *****
			case 1:
				if let unit = self.section_?.getUnits()[indexPath.row]
				{
					unit.section = nil
					self.section_!.removeFromUnits(unit)
				}
				break


			// **** PATTERN ****
			case 2:


				if let pattern = self.section_?.getPatterns()[indexPath.row]
				{
					let controller = UIAlertController(title: "FZG entfernen", message: "Welches Fahrzeug soll entfernt werden?", preferredStyle: .alert)


					for unit in pattern.units
					{
						let action = UIAlertAction(title: unit.callsign ?? "", style: .default, handler: {(alert: UIAlertAction!) in
							let victim = unit.getVictims()![0]
							victim.removeFromFahrzeug(unit)
							unit.removeFromPatient(victim)
							self.table.reloadData()
							let handler = SectionHandler()
							handler.saveData()
							self.dropDelegate.dropedUnitInSection()



						})
						controller.addAction(action)

						//unit.section = nil
						//self.section_!.removeFromUnits(unit)
					}
					let abort = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil)
					controller.addAction(abort)
					var parentResponder : UIResponder? = self
					while parentResponder != nil{
						parentResponder = parentResponder!.next
						if let viewController = parentResponder as? UIViewController{

							viewController.present(controller, animated: true, completion: nil)
							break
						}
					}
					//TODO: Controller presenten
					pattern.victim.section = nil
				}
				break
			default:
				break
			}




            let handler = SectionHandler()
            handler.saveData()
            self.table.reloadData()
            self.dropDelegate.dropedUnitInSection()
        }
        actions.append(delete)
        if(unit.patient != nil)
        {
            let removePatient = UITableViewRowAction(style: .normal, title: "Patient entfernen") { (action, indexPath) in
                let unit_ = (self.section_!.units!.allObjects as! [Unit]).sorted(by: { $0.callsign!.lowercased() < $1.callsign!.lowercased() })[indexPath.row]
                //Fahrzeugverknüpfung in Patientenobject wird gelöscht
                for vic in unit_.patient?.allObjects as! [Victim]
                {
                    vic.fahrzeug = nil
                }
                //set wird geleert
                unit_.patient = nil
                let handler = SectionHandler()
                handler.saveData()
                self.table.reloadData()
                self.dropDelegate.dropedUnitInSection()
            }
            removePatient.backgroundColor = UIColor.blue
            
            //actions.append(removePatient)
            var hasHospital = false
            for vic in unit.patient?.allObjects as! [Victim]
            {
                if vic.hospital != nil
                {
                    hasHospital = true
                    break
                }
            }
            if(hasHospital)
            {
                let removeHospital = UITableViewRowAction(style: .destructive, title: "Ziel entfernen") { (action, indexPath) in
                    // delete item at indexPath
                     let unit_ = (self.section_!.units!.allObjects as! [Unit]).sorted(by: { $0.callsign!.lowercased() < $1.callsign!.lowercased() })[indexPath.row]
                    for vic in unit_.patient?.allObjects as! [Victim]
                    {
                        vic.hospital = nil
                    }
                    //unit_.patient?.hospital = nil
                    let handler = SectionHandler()
                    handler.saveData()
                    self.table.reloadData()
                    self.dropDelegate.dropedUnitInSection()

                }
                removeHospital.backgroundColor = UIColor.lightGray
                actions.append(removeHospital)
            }
        }
        return actions
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		// ------- VICTIMS --------
		if indexPath.section == 0
		{
			//------- PATIENTS / VICTIMS
			
			let cell = table.dequeueReusableCell(withIdentifier: "SectionUnitTableViewCell") as! sectionUnitTableViewCell
			cell.patient_ = self.victims![indexPath.row]
			cell.unit_ = nil
			cell.type = .Victim
			cell.setProperties()
			cell.unitChangedDelegate = self

			return cell
		}


		// ------- Units --------
		else if indexPath.section == 1
		{

			let cell = table.dequeueReusableCell(withIdentifier: "SectionUnitTableViewCell") as! sectionUnitTableViewCell
			cell.type = .Unit
			cell.unit_ = self.units![indexPath.row]
			cell.patient_ = nil
			cell.delegate = self
			cell.setProperties()
			cell.unitChangedDelegate = self
			return cell
		}


		// ------- PATTERNS --------
		else if indexPath.section == 2
		{
			//------- PATTERNS

			

			let cell = table.dequeueReusableCell(withIdentifier: "SectionUnitTableViewCell") as! sectionUnitTableViewCell
			cell.type = .UnitPattern
			cell.unit_ = nil
			cell.patient_ = nil
			cell.pattern = self.patterns![indexPath.row]
			cell.delegate = self
			cell.setProperties()
			cell.unitChangedDelegate = self
			return cell
		}
		else
		{
			return UITableViewCell(style: .default, reuseIdentifier: "SectionUnitTableViewCell")
		}

        
    }
    
   
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    public var section_ : Section?
	public var units : [Unit]?
	public var patterns : [UnitPattern]?
	public var victims : [Victim]?
   public var dropDelegate : SectionDropProtocol!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var Abschnittname: UINavigationItem!
    @IBOutlet weak var lblKTW: UILabel!
    @IBOutlet weak var lblRTW: UILabel!
    @IBOutlet weak var lblNEF: UILabel!
    @IBOutlet weak var lblRTH: UILabel!
    
}
