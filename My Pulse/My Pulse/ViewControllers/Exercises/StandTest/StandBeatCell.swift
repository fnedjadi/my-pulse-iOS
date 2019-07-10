//
//  StandBeatCell.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class StandBeatCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleIndicatorLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
    }
    
    func configure(title: String, heartRate: Int) {
        if title.lowercased() == "assis" {
            self.indicatorView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        }
        else if title.lowercased() == "pic" {
            self.indicatorView.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        }
        else if title.lowercased() == "debout" {
            self.indicatorView.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        }
        self.heartRateLabel.text = "\(heartRate) bpm"
        self.titleIndicatorLabel.text = title.uppercased()
    }
}
