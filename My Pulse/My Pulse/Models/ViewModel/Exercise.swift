//
//  Exercise.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import UIKit

public class Exercise {
    var id: Int?
    var title: String?
    var image: UIImage?
    
    init(id: Int, title: String, image: UIImage) {
        self.id = id
        self.title = title
        self.image = image
    }
}
