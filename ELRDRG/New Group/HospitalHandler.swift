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
    
    public func BaseHospital_to_Hospital(baseHospital : BaseHospital) -> Hospital
    {
        let hospital = Hospital(context: AppDelegate.viewContext)
        hospital.name = baseHospital.name
        hospital.city = baseHospital.city

        return hospital
    }
    
    
    
    
    public func addBaseHospital(name : String, city : String) -> BaseHospital
    {
        let hospital = BaseHospital(context: AppDelegate.viewContext)
        hospital.name = name
        hospital.city = city
        saveData()
        return hospital
    }
    
    public func getAllHospitals() -> [BaseHospital]
    {
        let userRequest : NSFetchRequest<BaseHospital> = BaseHospital.fetchRequest()
        do
        {
            let basehospitals = try AppDelegate.viewContext.fetch(userRequest)

			//Basehotel implements comparable Protocol
			return basehospitals.sorted()


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
