//
//  User.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable {
    
    var id: Int?
    var email: String?
    var role: Int?
    var profileCompleted: Bool?
    var profileValidated: Int?
    var surname: String?
    var name: String?
    var date_registration: String?
    var answers: [Answers]?
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.id <- map["id"]
        self.email <- map["email"]
        self.role <- map["role"]
        self.profileCompleted <- map["profilecompleted"]
        self.profileValidated <- map["profilevalidated"]
        self.surname <- map["surname"]
        self.name <- map["name"]
        self.answers <- map["answers"]
    }
}
