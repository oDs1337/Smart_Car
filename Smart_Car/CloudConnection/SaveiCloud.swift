//
//  SaveiCloud.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 24/02/2021.
//

import Foundation
import CloudKit

class SaveiCloud
{
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    
    func saveToCloudResult(data: String, brand: String, plates: String)
    {
        let newData = CKRecord(recordType: "Data")
        newData.setValue(data, forKey: "fuel_consumption")
        newData.setValue(brand, forKey: "brand")
        newData.setValue(plates, forKey: "plates")
        
        privateDataBase.save(newData) { (record, error) in
            //  todo warning alert
            print(error)
            guard record != nil else { return }
            //  todo alert
            print("saved data in Data")
        }
    }
    
    
    func saveToCloudCar(brand: String, plates: String)
    {
        let newCar = CKRecord(recordType: "Car")
        newCar.setValue(brand, forKey: "brand")
        newCar.setValue(plates, forKey: "plates")
        
        privateDataBase.save(newCar) { (record, error) in
            //  todo warning alert
            print(error)
            guard record != nil else { return }
            //  todo save alert
            print("saved data in Car")
            
        }
    }
}
