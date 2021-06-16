//
//  HistoryController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 17/02/2021.
//

import UIKit
import GoogleMobileAds
import GoogleUtilities
import CloudKit
import Network


class HistoryController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    //let dataVC = Smart_Car.dataViewController()
    //let carVC = Smart_Car.carViewController()
    let VCController = VCsController()
    let carViewController = CarsController()
    let dataVC = dataViewController()
    var timer: Timer?
    let monitor = NWPathMonitor()
    var connectionExist:Bool = false
    var userConnectionChoice:Bool = false
    
    @IBOutlet weak var carViewContainer: UIView!
    
    @IBOutlet weak var whichPickerView: UISegmentedControl!
    
    @IBOutlet weak var historyButton: UITabBarItem!
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        
        //  ad managment
        let appId = "ca-app-pub-2859570082554006/1576697552"
        //let testAppId = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = appId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        

        
        
        setup()
        defaultConfig()
        // Do any additional setup after loading the view.
    }
    
    
    func connectionMonitor()
    {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied
            {
                
                self.connectionExist = true
                
                
            }
            else
            {
                self.connectionExist = false
                self.userConnectionChoice = false
                
               
                
            }
            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func checkingForConnection()
    {
        timer =  Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            if self.connectionExist == false && self.userConnectionChoice == false
            {
                self.noConnectionAlert()
                self.userConnectionChoice = true
                
            }
            else if self.connectionExist == true
            {
                self.hideNoConnectionViewController()
            }
                
        }
        
    }
    
    
    
    func noConnectionAlert()
    {
        
        
        let alert = UIAlertController(title:"warningNoConnectionTitle".localized, message: "warningNoConnectionDescription".localized, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in self.changeViewController()}))
        
        self.present(alert, animated: true)
    }
    
    func changeViewController()
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        
        
        
        self.present(newViewController, animated: true, completion: nil)

        
        /*
        self.performSegue(withIdentifier: "ChangeViewControllerID", sender: self)
 */
        
        
    }
    
    
    func hideNoConnectionViewController()
    {
        dismiss(animated: true, completion: nil)
    }
    
   
    func defaultConfig()
    {
        whichPickerView.setTitle("msgData".localized, forSegmentAt: 0)
        whichPickerView.setTitle("msgCars".localized, forSegmentAt: 1)
        whichPickerView.tintColor = .white
        
        whichPickerView.defaultConfiguration()
        whichPickerView.selectedConfiguration()
    }
    
    
    private func setup()
    {
        
        /*
        addChild(dataVC)
        addChild(carVC)
        
        viewContainer.addSubview(dataVC.view)
        viewContainer.addSubview(carVC.view)
        
        dataVC.didMove(toParent: self)
        carVC.didMove(toParent: self)
        
        /*
        dataVC.view.frame = self.view.bounds
        carVC.view.frame = self.view.bounds
        */
        carVC.view.isHidden = true
 */
        carViewContainer.isHidden = true
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        
        /*
        dataVC.view.isHidden = true
        carVC.view.isHidden = true
        */
        viewContainer.isHidden = true
        carViewContainer.isHidden = true
   
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            /*
            viewContainer.bringSubviewToFront(dataVC.view)
            dataVC.view.isHidden = false
            */
            viewContainer.isHidden = false
            break
        case 1:
            /*
            viewContainer.bringSubviewToFront(carVC.view)
            carVC.view.isHidden = false
            */
            carViewContainer.isHidden = false
            break
        default:
            break
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



