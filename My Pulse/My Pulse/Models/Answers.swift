//
//  Answers.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 02/06/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

class Answers : Mappable {
    
    var id: Int?
    var users_id: Int?
    var profile_questions_id: Int?
    var answer: String?
    
    
    init(profile_questions_id: Int, answer : String) {
        self.profile_questions_id = profile_questions_id
        self.answer = answer
    }
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.users_id <- map["users_id"]
        self.profile_questions_id <- map["profile_questions_id"]
        self.answer <- map["answer"]
    }
}
