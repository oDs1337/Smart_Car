//
//  VCsController.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 03/03/2021.
//

import UIKit


class VCsController: UIViewController {
    
    let dataVC = Smart_Car.dataViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    
    private func setup()
    {
        
        addChild(dataVC)
        
        view.addSubview(dataVC.view)
        
        dataVC.didMove(toParent: self)
        
        dataVC.view.frame = self.view.bounds
        
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
