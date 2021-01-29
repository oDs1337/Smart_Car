//
//  MathOperations.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 28/01/2021.
//

import Foundation

class MathOperations
{
    var fuelConsumption: String?
    var distance: String?
    
    //  calc fuel usage
    func fuelUsage(fuelConsumption: String, distance: String) -> Double
    {
        var result:Double = 0
        
        //  (fuel consumption / distance) * 100
        result = (NSString(string: fuelConsumption).doubleValue / NSString(string: distance).doubleValue) * 100
        
        
        
        return result
    }
}
