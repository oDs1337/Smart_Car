//
//  DataTableViewCell.swift
//  Smart_Car
//
//  Created by Tobiasz Mamcarczyk on 26/02/2021.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var platesLabel: UILabel!
    @IBOutlet var fcLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .black
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    
    
}
