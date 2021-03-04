//
//  QueryiCloud.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 04/03/2021.
//

import Foundation
import CloudKit


class QueryiCloud
{
    let privateDataBase = CKContainer.default().privateCloudDatabase
    var iCloudData = [CKRecord]()
    var iCloudCar = [CKRecord]()
    
    func queryData()
    {
        let query = CKQuery(recordType: "Car", predicate: NSPredicate(value: true))
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.iCloudCar = sortedRecords
            }
    }
    
    func queryCar()
    {
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.iCloudData = sortedRecords
            }
    }

}
