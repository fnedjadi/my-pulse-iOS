//
//  StandResultCell.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class StandResultCell: UITableViewCell {

    @IBOutlet weak var resultLabel: UILabel!
    
    var sitDataAVG: Int?
    var standDataAVG: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        if let sitDataAVG = sitDataAVG, let standDataAVG = standDataAVG {
            let standVal = ((standDataAVG * 100) / sitDataAVG) - 100
            resultLabel.text = "\(standVal)%"
        }
        else {
            resultLabel.text = "Error"
        }
    }
}
