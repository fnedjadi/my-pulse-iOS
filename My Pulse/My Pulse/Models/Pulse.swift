//
//  Pulse.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

public class Pulse: Mappable {
    
    var user_id: Int?
    var isTraining: Bool?
    var bpm_avg: Int?
    var bpm_min: Int?
    var bpm_max: Int?
    var nb_steps: Int?
    var date_min: String?
    var date_max: String?
    var source: String?
    
    init(isTraining : Bool, bpm_avg: Int, bpm_min: Int, bpm_max: Int, nb_steps: Int, date_min: String, date_max: String, source: String?) {
        self.user_id = UserDefaults().integer(forKey: "user_id")
        self.isTraining = isTraining
        self.bpm_avg = bpm_avg
        self.bpm_min = bpm_min
        self.bpm_max = bpm_max
        self.nb_steps = nb_steps
        self.date_min = date_min
        self.date_max = date_max
        self.source = source
    }
    
    // MARK: - ObjectMapper functions
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.user_id <- map["user_id"]
        self.isTraining <- map["isTraining"]
        self.bpm_avg <- map["bpm_avg"]
        self.bpm_min <- map["bpm_min"]
        self.bpm_max <- map["bpm_max"]
        self.nb_steps <- map["nb_steps"]
        self.date_min <- map["date_min"]
        self.date_max <- map["date_max"]
        self.source <- map["source"]
    }
}
