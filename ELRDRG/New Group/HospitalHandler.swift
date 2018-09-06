//
//  HospitalHandler.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 06.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import CoreData

class HospitalHandler: NSObject {
    
      var delegate : HospitalProtocol?
    
    public func deleteBaseHospital(basehospital : BaseHospital)
    {
        AppDelegate.viewContext.delete(basehospital)
        saveData()
    }
    
    
    
    
    
    public func addBaseHospital(name : String, city : String)
    {
        let hospital = BaseHospital(context: AppDelegate.viewContext)
        hospital.name = name
        hospital.city = city
        saveData()
    }
    
    public func getAllHospitals() -> [BaseHospital]
    {
        let userRequest : NSFetchRequest<BaseHospital> = BaseHospital.fetchRequest()
        do
        {
            let basehospitals = try AppDelegate.viewContext.fetch(userRequest)
            return basehospitals
        }
        catch
        {
            print(error)
        }
        return []
    }
    public func saveData()
    {
        //save to database
        do
        {
            try AppDelegate.viewContext.save()
        }
        catch
        {
            print(error)
        }
    }

}