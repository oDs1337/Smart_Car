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
import GoogleUtilities
import CloudKit


//  extensions

//  tab bar
extension UITabBar
{
    static func setTransparentTabbar()
    {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}

//  localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//  gad banner delegate
extension UIViewController: GADBannerViewDelegate{
    
    //  if ad works
    func adViewDidReciveAd(_ bannerView: GADBannerView)
    {
        print("ad received")
    }
    
    //  fetch error if ad doesn't work
    /*
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        print(error)
    }
    */
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
    let done: UIBarButtonItem = UIBarButtonItem(title: "buttonDone".localized, style: UIBarButtonItem.Style.done, target: self, action: myAction)

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
    var kindOfFuelResult:String = ""
    var kindOfDistance:String = ""
    var kindOfDistanceResult:String = ""
    var systemLanguage:String = ""
    let maxPossibleNumber:Int = 2147483647
    let privateDataBase = CKContainer.default().privateCloudDatabase
    var iCloudData = [CKRecord]()
    var iCloudCar = [CKRecord]()
    var brand = "All"
    var plates = ""
    var fuelSymbol = "l"
    var distanceSymbol = "km"
    
    //  init classes
    let math = MathOperations()
    let save = SaveiCloud()
    let dataVC = dataViewController()
    
    //  connect labels
    //  fuel constumption
    @IBOutlet weak var labelFuelConsumption: UILabel!
    
    //  submit button
    @IBOutlet weak var buttonCalculate: UIButton!
    
    //  add vehicle button
    @IBOutlet weak var vehicleOutlet: UIButton!
    
    
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
    
    //  view controllers
    @IBOutlet weak var vcOptions: UISegmentedControl!
    
    
    //  ad banner
    @IBOutlet weak var bannerView: GADBannerView!
    
    //  lock orientation: portrait
    private var _orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }
    
    //  picker view
    @IBOutlet var picker: UIPickerView!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        queryCar()
        
        
        
        picker.dataSource = self
        picker.delegate = self
        
        
        
        
        //  delegate to allow only numbers
        fuelConsumptionTextField.delegate = self
        distanceTextField.delegate = self
        
        
        
        //  ad managment
        let appId = "ca-app-pub-2859570082554006/1576697552"
        //let testAppId = "ca-app-pub-3940256099942544/2934735716"
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
        
        //  tab bar items
        self.tabBarController?.tabBar.items![0].title = "barCalculator"
        self.tabBarController?.tabBar.items![1].title = "barHistory"
        UITabBar.setTransparentTabbar()
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.6016128659, green: 0.8431326747, blue: 0.1667303443, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = .white
        
        
        
        
        //  color managment
        
        //  picker
        picker.setValue(UIColor.white, forKey: "textColor")
        
        //  add vehicle
        vehicleOutlet.tintColor = .white
        
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
        
        
        //  fetch device language
        systemLanguage = fetchLanguage()
        
        //  segmented control text
        fuelOptions.setTitle("msgLiters".localized, forSegmentAt: 0)
        fuelOptions.setTitle("msgGallons".localized, forSegmentAt: 1)
        
        distanceOptions.setTitle("msgKilometers".localized, forSegmentAt: 0)
        distanceOptions.setTitle("msgMiles".localized, forSegmentAt: 1)
        
        
        
        
        //  dismiss keyboard
        dismissKeyboard()
        
        //  default values of fuel and distance
        kindOfFuel = "msgLiters".localized
        kindOfFuelResult = "msgLitersResult".localized
        kindOfDistance = "msgKilometers".localized
        kindOfDistanceResult = "msgKilometersResult".localized
        
        //  default values of fuel consumption and distance labels
        labelFuelConsumption.text = "msgFuelConsumption".localized
        labelDistance.text = "msgDistance".localized
        
        //  default value of calculate button
        buttonCalculate.setTitle("buttonCalculate".localized, for: .normal)

        
        //  default placeholders
        fuelConsumptionTextField.placeholder = kindOfFuel
        distanceTextField.placeholder = kindOfDistance
    }
    
    //  query
    
   
    
    func queryCar()
    {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Car", predicate: predicate)
        
        privateDataBase.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate!})
            
            self.iCloudCar = sortedRecords
            
            DispatchQueue.main.async {
                // todo alert loading
                print(self.iCloudCar)
                self.picker.reloadAllComponents()
                sleep(3)
            }
            
        }
        
    }
    
    //  reload picker data
    func reloadPicerViewData()
    {
        DispatchQueue.main.async {
            sleep(3)
            print(self.iCloudCar)
            self.picker.reloadAllComponents()
        }
    }
    //  function to check if number is valuable to count
    func isNumberCorrect(answer: String) -> Bool
    {
        //  unwrapped because program already checked if fields are empty
        var result:Bool = false
        if isEmptyCheck(data: answer) == true
        {
            result = false
        }
        else
        {
        //  change comma to dot
        let numberAsString:String = commaToDot(data: answer)
        let number = Double(numberAsString)!
        
        
        if(number == 0 || number >= Double(maxPossibleNumber))
        {
            result = false
        }
        else
        {
            result = true
        }
        }
        
        return result
        
    }
    
    
    
    //  fetch device's language
    func fetchLanguage() -> String
    {
        //  fetch language settings
        let fetchDeviceLanguage:String = Locale.preferredLanguages[0]
        let index = fetchDeviceLanguage.index(fetchDeviceLanguage.startIndex, offsetBy: 2)
        let languageSettings = String(fetchDeviceLanguage.prefix(upTo: index))
        
        return languageSettings
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
            kindOfFuel = "msgLiters".localized
            kindOfFuelResult = "msgLitersResult".localized
            fuelSymbol = "l"
            //  change placeholder of fuel consumption
            fuelConsumptionTextField.placeholder = kindOfFuel
        }
        else if sender.selectedSegmentIndex == 1
        {
            kindOfFuel = "msgGallons".localized
            kindOfFuelResult = "msgGallonsResult".localized
            fuelSymbol = "gal"
            //  change placeholder of fuel consumption
            fuelConsumptionTextField.placeholder = kindOfFuel
        }
    }
    
    
    //  distance options
    @IBAction func didKindOfDistanceChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            kindOfDistance = "msgKilometers".localized
            kindOfDistanceResult = "msgKilometersResult".localized
            distanceSymbol = "km"
            //  change placeholder of distance
            distanceTextField.placeholder = kindOfDistance
        }
        else if sender.selectedSegmentIndex == 1
        {
            kindOfDistance = "msgMiles".localized
            kindOfDistanceResult = "msgMilesResult".localized
            distanceSymbol = "mi"
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
        var whichOptionIsEmpty = ""
        let alertMissingDataTitle = "msgEnterTheFollowingData".localized
        let messageContinue = "msgContinue".localized
        let messageSave = "msgSave".localized
        let messageDiscard = "msgDiscard".localized
        
        //  check if text fields are empty
        if isEmptyCheck(data: fuelConsumptionTextField.text!) == true && isEmptyCheck(data: distanceTextField.text!) == true
        {
            //  set background color to red so user will know which text fields are missed
            fuelConsumptionTextField.backgroundColor = .red
            distanceTextField.backgroundColor = .red
            
            whichOptionIsEmpty = "msgFuelConsumptionAndDistance".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == true && isEmptyCheck(data: distanceTextField.text!) == false
        {
            //  set background color to red
            fuelConsumptionTextField.backgroundColor = .red
            //  set background color to green
            distanceTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "msgFuelConsumption".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == true
        {
            //  set background color to red
            distanceTextField.backgroundColor = .red
            //  set background color to gree
            fuelConsumptionTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "msgDistance".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        //  check if numbers are != 0 and < maxPossibleNumber
        else if isNumberCorrect(answer: fuelConsumptionTextField.text!) == false && isNumberCorrect(answer: distanceTextField.text!) == false
        {
            //  set background color to red so user will know which text fields are missed
            fuelConsumptionTextField.backgroundColor = .red
            distanceTextField.backgroundColor = .red
            
            whichOptionIsEmpty = "msgFuelConsumptionAndDistance".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if isNumberCorrect(answer: fuelConsumptionTextField.text!) == false
        {
            //  set background color to red
            fuelConsumptionTextField.backgroundColor = .red
            //  set background color to green
            distanceTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "msgFuelConsumption".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if isNumberCorrect(answer: distanceTextField.text!) == false
        {
            //  set background color to red
            distanceTextField.backgroundColor = .red
            //  set background color to gree
            fuelConsumptionTextField.backgroundColor = #colorLiteral(red: 0.6011776924, green: 0.8441928029, blue: 0.1656403244, alpha: 1)
            
            whichOptionIsEmpty = "msgDistance".localized
            let alert = UIAlertController(title: alertMissingDataTitle, message: whichOptionIsEmpty, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemRed
            alert.addAction(UIAlertAction(title: messageContinue, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        //  calc result
        else if isEmptyCheck(data: fuelConsumptionTextField.text!) == false && isEmptyCheck(data: distanceTextField.text!) == false
        {
            fuelConsumption = commaToDot(data: fuelConsumptionTextField.text!)
            distance = commaToDot(data: distanceTextField.text!)

            
            let finalResultAsString = NSString(string: String(format: "%.2f",math.fuelUsage(fuelConsumption: fuelConsumption, distance: distance)))
            
            //labelResult.text = "\(finalResultAsString) \(kindOfFuel)/100 \(kindOfDistance)"
            
            //  alert with result of fuel usage
            let alert = UIAlertController(title: "msgYourFuelConsumptionIs".localized, message: "\(finalResultAsString) \(kindOfFuelResult)/100 \(kindOfDistanceResult) and it's going to be saved in brand \(brand) with plates \(plates)", preferredStyle: .alert)
                        
            
            
            let result = "\(finalResultAsString) \(self.fuelSymbol)/100 \(self.distanceSymbol)"
            
            
            let save = UIAlertAction(title: messageSave, style: .default){ (_) in
                
                
                
            self.save.saveToCloudResult(data: result, brand: self.brand, plates: self.plates)
                
            
                
                
            }
            alert.addAction(UIAlertAction(title: messageDiscard, style: .cancel, handler: nil))
            alert.addAction(save)
            self.present(alert, animated: true, completion: nil)
 
            //  erase data to continue
            eraseDataInTextFields()
            //  refresh history view
            
            
        }
        
        
        
    }
    
    @IBAction func addVehicle(_ sender: Any) {
        
        //  todo localization
        // Create alert controller
           let alertController = UIAlertController(title: "Add new car", message: "Input brand and your plates", preferredStyle: .alert)

           // add textfield at index 0
           alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
               textField.placeholder = "Brand"

           })

           // add textfield at index 1
           alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
               textField.placeholder = "Plates"

           })

           // Alert action confirm
           let confirmAction = UIAlertAction(title: "Save", style: .default, handler: {(_ action: UIAlertAction) -> Void in
               print("Brand: \(String(describing: alertController.textFields?[0].text))")
               print("Plates: \(String(describing: alertController.textFields?[1].text))")
                
            if (alertController.textFields?[0].text == "" || alertController.textFields?[1].text == "")
            {
                let alertWarning = UIAlertController(title: "msgWarning", message: "msgYou need to enter all data to save your car informations", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "msgCancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                                    print("Canelled")})
                
                alertWarning.addAction(cancelAction)
                self.present(alertWarning, animated: true, completion: nil)
                
                
            }
            else if(alertController.textFields?[0].text?.count ?? 11 > 10)
            {
                let alertWarning = UIAlertController(title: "msgWarning", message: "msgBrand can't be longer than 10 characters", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "msgCancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                                    print("Canelled")})
                
                alertWarning.addAction(cancelAction)
                self.present(alertWarning, animated: true, completion: nil)
            }
            else if(alertController.textFields?[1].text?.count ?? 11 > 10)
            {
                let alertWarning = UIAlertController(title: "msgWarning", message: "msgPlates can't be longer than 10 character", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "msgCancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                                    print("Canelled")})
                
                alertWarning.addAction(cancelAction)
                self.present(alertWarning, animated: true, completion: nil)
                
            }
            else
            {
                let brand = alertController.textFields?[0].text
                let plates = alertController.textFields?[1].text
            
                self.save.saveToCloudCar(brand: brand ?? "" , plates: plates ?? "")
            
                sleep(3)
                self.queryCar()
            }
           })
           alertController.addAction(confirmAction)

           // Alert action cancel
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
               print("Canelled")
           })
           alertController.addAction(cancelAction)

           // Present alert controller
           present(alertController, animated: true, completion: nil)
        
    }
    
    

}

extension ViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        

        return iCloudCar.count + 1
    }
    
    
}


extension ViewController: UIPickerViewDelegate
{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int) -> String? {
        
        var result:String = ""
        let separator:String = " | "
        
        if(row == 0)
        {
            //  todo translation
            result = "All"
            
        }
        else
        {
            
            result = self.iCloudCar[row - 1].object(forKey: "brand") as! String
            result += separator
            result += self.iCloudCar[row - 1].object(forKey: "plates") as! String
            
        }
        
        return result
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
       {
            if(row == 0)
            {
                brand = "All"
                plates = ""
             
            }
            else
            {
                brand = self.iCloudCar[row - 1].object(forKey: "brand") as! String
                plates = self.iCloudCar[row - 1].object(forKey: "plates") as! String
                
            }
            
           
            
        }
}
