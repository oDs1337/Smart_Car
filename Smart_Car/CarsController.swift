//
//  CarsController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 03/03/2021.
//

import UIKit

class CarsController: UIViewController {
    
    let carVC = Smart_Car.carViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    
    private func setup()
    {
        
        addChild(carVC)
        
        view.addSubview(carVC.view)
        
        carVC.didMove(toParent: self)
        
        carVC.view.frame = self.view.bounds
        
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
