//
//  RoundButton.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
