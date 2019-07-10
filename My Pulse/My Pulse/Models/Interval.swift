//
//  Interval.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 08/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

public class Interval: Mappable {
    
    var bpm_avg: Int?
    var bpm_min: Int?
    var bpm_max: Int?
    var date: Date?
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.bpm_avg <- map["bpm_avg"]
        self.bpm_min <- map["bpm_min"]
        self.bpm_max <- map["bpm_max"]
        self.date <- map["date"]
    }
}
