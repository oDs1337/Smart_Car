//
//  ViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/01/2021.
//

import UIKit

//  extensions
//  placeholder colors
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

//  segmented control text color
extension UISegmentedControl
{
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}


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
    
    //  connect options
    //  fuel
    @IBOutlet weak var fuelOptions: UISegmentedControl!
    
    //  distance
    @IBOutlet weak var distanceOptions: UISegmentedControl!
    
    
    
    
    
    
    

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
       
        //  color managment
        //  fuel consumption
        fuelConsumptionTextField.backgroundColor = #colorLiteral(red: 0.6016128659, green: 0.8431326747, blue: 0.1667303443, alpha: 1)
        fuelConsumptionTextField.placeHolderColor = .white
        fuelOptions.defaultConfiguration()
        fuelOptions.selectedConfiguration()
        fuelConsumptionTextField.textColor = .black
        
        //  distance
        distanceTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
        distanceTextField.placeHolderColor = .white
        distanceOptions.defaultConfiguration()
        distanceOptions.selectedConfiguration()
        distanceTextField.textColor = .black
        
        
        //  segmented control
        
        
        
        
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
    
    //  switch comma with dot to make calc easier
    func commaToDot(data: String) -> String
    {
        let result:String = data.replacingOccurrences(of: ",", with: ".")
        
        return result
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
        //  init important variables
        var fuelConsumption:String = ""
        var distance:String = ""
        
        
        
        if isEmptyCheck(data: fuelConsumptionTextField.text!) == true || isEmptyCheck(data: distanceTextField.text!) == true
        {
            labelResult.text = "input data"
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == false
        {
            fuelConsumption = commaToDot(data: fuelConsumptionTextField.text!)
            distance = commaToDot(data: distanceTextField.text!)

            
            let finalResultAsString = NSString(string: String(format: "%.2f",math.fuelUsage(fuelConsumption: fuelConsumption, distance: distance)))
            
            labelResult.text = "\(finalResultAsString) \(kindOfFuel)/100 \(kindOfDistance)"
        }
        
        
    }
    
    

}

