//
//  Constants.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire

struct Constants {
    
    struct Url {
        // URL
        static let ENTRY_API_URL = "https://api.mypulse.eu/"
        
        // PULSES
        static let PULSES = "pulses/"
        static let TODAY = "today/"
        static let LAST = "last/"
        static let INTERVALS = "intervals/"
        
        //USERS
        static var USERS : String {
            var url = "users/"
            if let id = UserDefaults().string(forKey: "user_id") {
                url += id + "/"
            }
            return url
        }
        static let LOGIN = "login/"
        static let QUESTIONS = "questions/"
        static let ANSWERS = "answers/"
    }
    
    struct Headers {
        static let Api_Key = "UHmCSEkccmnxW6a5MEhpUuKuHGQtyf9e"
        static let headers: HTTPHeaders = [
            "api_key": Headers.Api_Key
        ]
    }
}
