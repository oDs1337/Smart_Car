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
    @IBOutlet var picker: UIPickerView!
    
    let query = QueryiCloud()
    let cellLabels = DataTableViewCell()
    let heighCell = 44
    let delimeter = " "
    var brand = ""
    var plates = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .black
        picker.dataSource = self
        picker.delegate = self
        picker.setValue(UIColor.white, forKey: "textColor")
        

        query.queryCar()
        reloadComponents()
        query.queryData()
        reloadComponents()
        
        
        
        // Do any additional setup after loading the view.
    }
    func reloadComponents()
    {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            self.picker.reloadAllComponents()
            sleep(3)
        }
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
        return query.iCloudData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        
        cell.brandLabel?.text = query.iCloudData[indexPath.row].value(forKey: "brand") as! String
        cell.platesLabel?.text = query.iCloudData[indexPath.row].value(forKey: "plates") as! String
        cell.fcLabel?.text = query.iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String
        var number = fetchNumberResult(resultAsString: query.iCloudData[indexPath.row].value(forKey: "fuel_consumption") as! String, delimiter: delimeter)
        if number <= 10
        {
            cell.fcLabel?.textColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
        }
        else if number > 10 && number < 15
        {
            cell.fcLabel?.textColor = #colorLiteral(red: 1, green: 0.9882281123, blue: 0.1349969075, alpha: 1)
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
extension dataViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        

        return query.iCloudCar.count + 1
    }
    
    
}

extension dataViewController: UIPickerViewDelegate
{
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int) -> String? {
        
        var result:String = ""
        let separator:String = " | "
        
        if(row == 0)
        {
            //  todo translation
            result = "All"
            brand = "All"
        }
        else if(row > 0)
        {
            brand = self.query.iCloudCar[row - 1].object(forKey: "brand") as! String
            plates = self.query.iCloudCar[row - 1].object(forKey: "plates") as! String
            result = self.query.iCloudCar[row - 1].object(forKey: "brand") as! String
            result += separator
            result += self.query.iCloudCar[row - 1].object(forKey: "plates") as! String
            
        }
        
        return result
    }
}
