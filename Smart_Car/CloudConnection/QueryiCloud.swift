//
//  QueryiCloud.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 24/02/2021.
//

import Foundation
import CloudKit

class QueryiCloud
{
    let privateDataBase = CKContainer.default().privateCloudDatabase
    var iCloudData = [CKRecord]()
    var iCloudCar = [CKRecord]()
    let vc = ViewController()
    
    func queryData()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Data", predicate: predicate)
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            
            self.iCloudData = sortedRecords
            self.vc.reloadPickerView()
        }
    }
    
    func queryCar()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Car", predicate: predicate)
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            
            self.iCloudCar = sortedRecords
            self.vc.reloadPickerView()
        }
    }
}
