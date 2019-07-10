//
//  Questions.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 23/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import ObjectMapper

class Questions: Mappable {
    
    var id: Int?
    var key_name: String?
    var question: String?
    var answer_type: String?
    var answers: [String]?
    var position: Int?
    
    
    // MARK: - ObjectMapper functions
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.id <- map["id"]
        self.key_name <- map["key_name"]
        self.question <- map["question"]
        self.answer_type <- map["answer_type"]
        self.answers <- map["answers"]
        self.position <- map["position"]
    }
}
