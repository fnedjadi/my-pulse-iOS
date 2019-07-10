//
//  MPDataTableViewCell.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 31/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class MPDataTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroungViewCell: UIView!
    
    @IBOutlet weak var heartRateBackground: UIView!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroungViewCell?.layer.cornerRadius = 8
        
        self.backgroungViewCell?.layer.shadowColor = UIColor.black.cgColor
        self.backgroungViewCell?.layer.shadowOpacity = 0.5
        self.backgroungViewCell?.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.backgroungViewCell?.layer.shadowRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func drawCircle(forvalue value : Int) {
        let linewidth : CGFloat = 4.0
        let width: CGFloat = heartRateBackground.bounds.width
        let height: CGFloat = heartRateBackground.bounds.height
        let center: CGPoint = CGPoint(x: heartRateBackground.bounds.midX, y: heartRateBackground.bounds.midY)
        let radius: CGFloat = min(width, height)/3 - linewidth
        let start: CGFloat = 0
        let end: CGFloat = CGFloat.pi * 2

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: start,
                                endAngle: end,
                                clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Utils.colorBpm(value: value).cgColor
        activityLabel.text = Utils.textBpm(value: value)
        shapeLayer.lineWidth = linewidth

        heartRateBackground.layer.addSublayer(shapeLayer)
    }
}
