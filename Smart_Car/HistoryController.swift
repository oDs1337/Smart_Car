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


class HistoryController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    let dataVC = Smart_Car.dataViewController()
    let carVC = Smart_Car.carViewController()
    
    @IBOutlet weak var whichPickerView: UISegmentedControl!
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        
        addChild(dataVC)
        addChild(carVC)
        
        viewContainer.addSubview(dataVC.view)
        viewContainer.addSubview(carVC.view)
        
        dataVC.didMove(toParent: self)
        carVC.didMove(toParent: self)
        
        dataVC.view.frame = self.view.bounds
        carVC.view.frame = self.view.bounds
        carVC.view.isHidden = true
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        
        
        dataVC.view.isHidden = true
        carVC.view.isHidden = true
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            viewContainer.bringSubviewToFront(dataVC.view)
            dataVC.view.isHidden = false
            break
        case 1:
            viewContainer.bringSubviewToFront(carVC.view)
            carVC.view.isHidden = false
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



