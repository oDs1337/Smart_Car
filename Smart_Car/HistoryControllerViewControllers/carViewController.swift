//
//  carViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/02/2021.
//

import UIKit
import CloudKit

class carViewController: UIViewController, UITableViewDelegate  {
    
    
    @IBOutlet var tableView: UITableView!

    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    let cellLabels = DataTableViewCell()
    var iCloudCars = [CKRecord]()
    let heighCell = 44
    let delimeter = " "
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "msgPullToRefresh".localized)
        refreshControl.addTarget(self, action: #selector(queryCars), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        let nib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        reloadCars()
        queryCars()
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func appMovedToBackground()
    {
        
        disableReloadData()
    }
    @objc func appMovedToForeground()
    {
        
        reloadCars()
    }
    
    func reloadCars()
    {
        
        
        timer =  Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { (timer) in
            self.queryCars()
                
        }
        
        
        
    }
    
    func disableReloadData()
    {
        if timer != nil {
               timer?.invalidate()
               timer = nil
           }
    }
    
    @objc public func queryCars()
    {
        let query = CKQuery(recordType: "Car", predicate: NSPredicate(value: true))
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.iCloudCars = sortedRecords
            print(self.iCloudCars)
            DispatchQueue.main.async {
                
                //let recordsCounter:Int = self.iCloudData.count
                //self.scrollFix(recordsCounter: recordsCounter, heightCell: self.heighCell)
                
                self.tableView?.refreshControl?.endRefreshing()
                self.tableView?.reloadData()
                print(self.iCloudCars)
                
                
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

extension carViewController: UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return iCloudCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        var date:NSDate = iCloudCars[indexPath.row].value(forKey: "modificationDate") as! NSDate
        var dateAsString = "\(date)".prefix(10)
        
        
        cell.brandLabel?.text = iCloudCars[indexPath.row].value(forKey: "brand") as! String
        
        cell.platesLabel?.text = iCloudCars[indexPath.row].value(forKey: "plates") as! String
        
        cell.fcLabel?.textColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
        cell.fcLabel?.text = "\(dateAsString)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            let recordID: CKRecord.ID = iCloudCars[indexPath.row].recordID
            iCloudCars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            privateDataBase.delete(withRecordID: recordID) { (record, error) in
                print(error)
                guard record != nil else { return }
                print("removed record successfully")
            }
            
        }
    }
    
    
    
   
}
