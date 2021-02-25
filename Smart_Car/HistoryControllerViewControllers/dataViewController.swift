//
//  dataViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/02/2021.
//

import UIKit
import CloudKit

class dataViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    var iCloudData = [CKRecord]()
    var iCloudCar = [CKRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.delegate = self
        view.backgroundColor = .black
        
        queryCar()
        queryData()
        // Do any additional setup after loading the view.
    }
    
    @objc func queryCar()
    {
        let query = CKQuery(recordType: "Car", predicate: NSPredicate(value: true))
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.iCloudCar = sortedRecords
            print(self.iCloudData)
            DispatchQueue.main.async {
                
                
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                
                sleep(3)
            }
            
        }
    }

    @objc func queryData()
    {
        let query = CKQuery(recordType: "Data", predicate: NSPredicate(value: true))
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.iCloudData = sortedRecords
            print(self.iCloudData)
            DispatchQueue.main.async {
                
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                print(self.iCloudData)
                sleep(3)
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension dataViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iCloudData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String
        cell.textLabel?.text = note
        
        return cell
    }
    
    
}
