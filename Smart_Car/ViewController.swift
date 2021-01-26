//
//  ViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //  connect labels
    //  fuel constumption
    @IBOutlet weak var labelFuelConsumption: UILabel!
    
    //  distance
    @IBOutlet weak var labelDistance: UILabel!
    
    //  result
    @IBOutlet weak var labelResult: UILabel!
    
    
    //  connect text fields
    //  fuel text field
    @IBOutlet weak var fuelConsumptionTextField: UITextField!
    
    //  distance text field
    @IBOutlet weak var distanceTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //  connect options
    //  fuel options
    @IBAction func fuelOptions(_ sender: Any) {
    }
    
    //  distance options
    @IBAction func distanceOptions(_ sender: Any) {
    }
    
    //  connect buttons
    @IBAction func submitButton(_ sender: Any) {
    }
    
    

}

