//
//  BusinessManager.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire

class BusinessManager {
    static func getUsers(completed: @escaping ((_ response:User?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getUsers(completed: { (res, error) in
            completed(res, error)
        })
    }
    
    static func getQuestions(completed: @escaping ((_ response:[Questions]?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getQuestions { (res, error) in
            completed(res, error)
        }
    }
    
    static func postLogin(email: String, password: String, completed: @escaping ((_ response:Login?, _ error:Error?) -> Void)) -> Void {
        DataAccess.postLogin(email: email, password: password, completed: { (res, error) in
            completed(res, error)
        })
    }
    
    static func postUser(email: String, password: String, name: String, surname:String, completed: @escaping ((_ response:User?, _ error:Error?) -> Void)) -> Void {
        DataAccess.postUser(email: email, password: password, name: name, surname: surname) { (res, error) in
            completed(res, error)
        }
    }
    
    static func postAnswers(answers: [Answers], completed: @escaping ((_ response: [Answers]?, _ error:Error?) -> Void)) -> Void {
        DataAccess.postAnswers(answers: answers) { (res, error) in
            completed(res, error)
        }
    }
    
    static func putUser(email: String, name: String, surname:String, completed: @escaping ((_ response:User?, _ error:Error?) -> Void)) -> Void {
        DataAccess.putUser(email: email, name: name, surname: surname) { (res, error) in
            completed(res, error)
        }
    }
}
