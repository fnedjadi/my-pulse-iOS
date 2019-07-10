//
//  Activity.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 07/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

public class Activity: Mappable {
    
    var user_id: Int?
    var avg: Int?
    var min: Int?
    var max: Int?
    var date: String?
    var arrActivity: [Pulse]?
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.user_id <- map["user_id"]
        self.avg <- map["avg"]
        self.min <- map["min"]
        self.max <- map["max"]
        self.date <- map["date"]
        self.arrActivity <- map["arrActivity"]
    }
}
