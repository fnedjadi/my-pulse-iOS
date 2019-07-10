//
//  StandDateCell.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class StandDateCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        let date = Date()
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMM yyyy"
        dateLabel.text = dateFormatter.string(from: date).capitalized
    }
}
