//
//  ViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/01/2021.
//

import UIKit

//  extensions


class ViewController: UIViewController, UITextFieldDelegate {
    
    //  init important variables
    var kindOfFuel:String = ""
    var kindOfDistance:String = ""
    
    //  init classes
    var math = MathOperations()
    
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
        
        //  delegate to allow only numbers
        fuelConsumptionTextField.delegate = self
        distanceTextField.delegate = self
        
        //  init default config
        defaultConfig()
        
        
        
    }
    
    //  Allow to fetch only numbers
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let withDecimal = (
            string == NumberFormatter().decimalSeparator &&
            textField.text?.contains(string) == false
        )
        return isNumber || withDecimal
    }
    
    
    //  default config
    func defaultConfig()
    {
       
        
        //  dismiss keyboard
        dismissKeyboard()
        
        //  default values of fuel and distance
        kindOfFuel = "Liters"
        kindOfDistance = "Kilometers"
        
        //  default value of result label
        labelResult.text = ""
        
        //  default placeholders
        fuelConsumptionTextField.placeholder = kindOfFuel
        distanceTextField.placeholder = kindOfDistance
    }
    
    //  dismiss decimal pad by touching anywhere
    func dismissKeyboard()
    {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    //  check if string is empty
    /*
        result: true = is empty
        result: false = is not empty
     */
    func isEmptyCheck(data: String) -> Bool
    {
        var result:Bool = true
        
        if data.isEmpty
        {
            result = true
        }
        else if data.isEmpty != true
        {
            result = false
        }
        else
        {
            result = true
        }
        
        return result
    }
    
    //  connect options
    //  fuel options
    @IBAction func didKindOfFuelChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            kindOfFuel = "Liters"
            //  change placeholder of fuel consumption
            fuelConsumptionTextField.placeholder = kindOfFuel
        }
        else if sender.selectedSegmentIndex == 1
        {
            kindOfFuel = "Gallons"
            //  change placeholder of fuel consumption
            fuelConsumptionTextField.placeholder = kindOfFuel
        }
    }
    
    
    //  distance options
    @IBAction func didKindOfDistanceChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            kindOfDistance = "Kilometers"
            //  change placeholder of distance
            distanceTextField.placeholder = kindOfDistance
        }
        else if sender.selectedSegmentIndex == 1
        {
            kindOfDistance = "Miles"
            //  change placeholder of distance
            distanceTextField.placeholder = kindOfDistance
        }
    }
    
    //  connect buttons
    @IBAction func submitButton(_ sender: Any)
    {
        var fuelConsumption:String = ""
        var distance:String = ""
        
        if isEmptyCheck(data: fuelConsumptionTextField.text!) == true || isEmptyCheck(data: distanceTextField.text!) == true
        {
            labelResult.text = "input data"
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == false
        {
            fuelConsumption = fuelConsumptionTextField.text!
            distance = distanceTextField.text!
            
            let finalResult:Double = math.fuelUsage(fuelConsumption: fuelConsumption, distance: distance)
            labelResult.text = "\(finalResult) \(kindOfFuel)/100 \(kindOfDistance)"
        }
        
        
    }
    
    

}

