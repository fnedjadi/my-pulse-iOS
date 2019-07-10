//
//  Login.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 15/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

public class Login: Mappable {
    
    var status: String?
    var token: String?
    var user: User?
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.token <- map["status"]
        self.token <- map["token"]
        self.user <- map["user"]
    }
}
