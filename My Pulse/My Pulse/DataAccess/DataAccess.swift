//
//  DataAccess.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class DataAccess {
    static func getUsers(completed: @escaping ((_ response:User?, _ error:Error?) -> Void)) -> Void {
        Alamofire.request(Router.getUsers())
            .validate()
            .responseObject { (alamoResponse: DataResponse<User>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func getQuestions(completed: @escaping ((_ response:[Questions]?, _ error:Error?) -> Void)) -> Void {
        let urlRequest = Router.getQuestions()
        Alamofire.request(urlRequest)
            .validate()
            .responseArray { (alamoResponse: DataResponse<[Questions]>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func postLogin(email: String, password: String, completed: @escaping ((_ response: Login?, _ error:Error?) -> Void)) -> Void {
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        Alamofire.request(Router.postLogin().path, method: Router.postLogin().method, parameters: parameters, encoding: JSONEncoding.default, headers: [:])
            .validate()
            .responseObject { (alamoResponse: DataResponse<Login>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func postUser(email: String, password: String, name: String, surname: String, completed: @escaping ((_ response: User?, _ error:Error?) -> Void)) -> Void {
        let parameters: Parameters = [
            "email": email,
            "password": password,
            "role":0,
            "name": name,
            "surname": surname
        ]
        // TODO : Change "Login : Mappable" response
        Alamofire.request(Router.postUser().path, method: Router.postUser().method, parameters: parameters, encoding: JSONEncoding.default, headers: [:])
            .validate()
            .responseObject { (alamoResponse: DataResponse<User>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func postAnswers(answers: [Answers], completed: @escaping ((_ response: [Answers]?, _ error:Error?) -> Void)) -> Void {
        var datas: [Parameters] = []
        answers.forEach {
            datas.append([
            "profile_questions_id": $0.profile_questions_id ?? "",
            "answer": $0.answer ?? ""
            ])
        }
        
        var request = Router.postAnswers().asURLRequest()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: datas)
        
        Alamofire.request(request)
            .validate()
            .responseArray(completionHandler: { (alamoResponse: DataResponse<[Answers]>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
            })
    }
    
    static func putUser(email: String, name: String, surname: String, completed: @escaping ((_ response: User?, _ error:Error?) -> Void)) -> Void {
        let parameters: Parameters = [
            "email": email,
            "name": name,
            "surname": surname
        ]
        let token = UserDefaults().string(forKey: "token") ?? ""
        
        Alamofire.request(Router.putUser().path, method: Router.putUser().method, parameters: parameters, encoding: JSONEncoding.default, headers:  [ "Authorization" : "Bearer \(token)" ])
            .validate()
            .responseObject { (alamoResponse: DataResponse<User>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
}

