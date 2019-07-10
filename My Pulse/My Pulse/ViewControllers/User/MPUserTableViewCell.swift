//
//  MPUserTableViewCell.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 31/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import HealthKit

class MPUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.leftLabel.textColor = UIColor.black
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
