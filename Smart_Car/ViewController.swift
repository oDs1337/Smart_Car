//
//  ViewController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 25/01/2021.
//
//  APP ID: pub-2859570082554006 / google.com, pub-2859570082554006, DIRECT, f08c47fec0942fa0
//  APP ID2?: ca-app-pub-2859570082554006~2642367215
//  UNIT ID: ca-app-pub-2859570082554006/1576697552


import UIKit
import GoogleMobileAds


//  extensions


//  gad banner delegate
extension UIViewController: GADBannerViewDelegate{
    
    //  if ad works
    func adViewDidReciveAd(_ bannerView: GADBannerView)
    {
        print("ad received")
    }
    
    //  fetch error if ad doesn't work
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        print(error)
    }
    
}

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

//  decimal pad buttons
extension UITextField{

 func addDoneButtonToKeyboard(myAction:Selector?){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
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
    
    //  ad banner
    @IBOutlet weak var bannerView: GADBannerView!
    
    //  lock orientation: portrait
    private var _orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //  delegate to allow only numbers
        fuelConsumptionTextField.delegate = self
        distanceTextField.delegate = self
        
        
        
        //  ad managment
        let appId = "ca-app-pub-2859570082554006/1576697552"
        let testAppId = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = appId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        //  add buttons to decimal pads
        fuelConsumptionTextField.addDoneButtonToKeyboard(myAction:  #selector(self.fuelConsumptionTextField.resignFirstResponder))
        distanceTextField.addDoneButtonToKeyboard(myAction:  #selector(self.distanceTextField.resignFirstResponder))
        
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
        
        
      
        
        
        
        //  dismiss keyboard
        dismissKeyboard()
        
        //  default values of fuel and distance
        kindOfFuel = "Liters"
        kindOfDistance = "Kilometers"

        
        //  default placeholders
        fuelConsumptionTextField.placeholder = kindOfFuel
        distanceTextField.placeholder = kindOfDistance
    }
    
    //  erase data in text fields
    func eraseDataInTextFields()
    {
        fuelConsumptionTextField.text = ""
        fuelConsumptionTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
        distanceTextField.text = ""
        distanceTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
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
        var whichOptionIsEmpty = "Fuel consumption and Distance"
        let alertMissingDataTitle = "Enter the following data"
        
        
        
        if isEmptyCheck(data: fuelConsumptionTextField.text!) == true && isEmptyCheck(data: distanceTextField.text!) == true
        {
            //  set background color to red so user will know which text fields are missed
            fuelConsumptionTextField.backgroundColor = .red
            distanceTextField.backgroundColor = .red
            
            whichOptionIsEmpty = "Fuel consumption and Distance"
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == true && isEmptyCheck(data: distanceTextField.text!) == false
        {
            //  set background color to red
            fuelConsumptionTextField.backgroundColor = .red
            //  set background color to green
            distanceTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "Fuel consumption"
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == true
        {
            //  set background color to red
            distanceTextField.backgroundColor = .red
            //  set background color to gree
            fuelConsumptionTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "Distance"
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == false
        {
            fuelConsumption = commaToDot(data: fuelConsumptionTextField.text!)
            distance = commaToDot(data: distanceTextField.text!)

            
            let finalResultAsString = NSString(string: String(format: "%.2f",math.fuelUsage(fuelConsumption: fuelConsumption, distance: distance)))
            
            //labelResult.text = "\(finalResultAsString) \(kindOfFuel)/100 \(kindOfDistance)"
            
            //  alert with result of fuel usage
            let alert = UIAlertController(title: "Your fuel consumption is:", message: "\(finalResultAsString) \(kindOfFuel)/100 \(kindOfDistance)", preferredStyle: .alert)
                        
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            //  erase data to continue
            eraseDataInTextFields()
            
            
        }
        
        
        
        
    }
    
    

}

