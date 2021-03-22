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
    
    let cellLabels = DataTableViewCell()
    var iCloudData = [CKRecord]()
    var iCloudCar = [CKRecord]()
    let heighCell = 44
    let delimeter = " "
    var brand = "All"
    var plates = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .black
        
        

        queryCar()
        queryData()
        
        
        // Do any additional setup after loading the view.
    }
    
    func fetchNumberResult(resultAsString:String, delimiter:String) -> Double
    {
        let result = resultAsString.components(separatedBy: delimiter).first
        if let number = Double(result!)
        {
            return number
        }
        else
        {
            return 0
        }
        
    }
    
    func scrollFix(recordsCounter:Int, heightCell:Int)
    {
        let result:CGFloat = CGFloat(recordsCounter * heightCell)
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: result,right: 0)
  
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
                
                print(self.iCloudCar)
                
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
                
                //let recordsCounter:Int = self.iCloudData.count
                //self.scrollFix(recordsCounter: recordsCounter, heightCell: self.heighCell)
                self.tableView?.refreshControl?.endRefreshing()
                self.tableView?.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        
        
        cell.brandLabel?.text = iCloudData[indexPath.row].value(forKey: "brand") as! String
        cell.platesLabel?.text = iCloudData[indexPath.row].value(forKey: "plates") as! String
        cell.fcLabel?.text = iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String
        
        var number = fetchNumberResult(resultAsString: iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String, delimiter: delimeter)
        if number <= 10
        {
            cell.fcLabel?.textColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
        }
        else if number > 10 && number < 15
        {
            cell.fcLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.4657245048, blue: 0, alpha: 1)
        }
        else if number >= 15
        {
            cell.fcLabel?.textColor = #colorLiteral(red: 1, green: 0, blue: 0.0187217119, alpha: 1)
        }
        else
        {
            cell.fcLabel?.textColor = .white
        }
        /*
        let note = iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String
        cell.textLabel?.text = note
        */
        return cell
    }
    
    
}


