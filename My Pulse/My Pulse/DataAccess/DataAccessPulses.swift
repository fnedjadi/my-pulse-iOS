//
//  DataAccessPulses.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 05/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

extension DataAccess {
    
    static func getPulses(offset: Int, limit: Int, date: Date?, completed: @escaping ((_ response:[Activity]?, _ error:Error?) -> Void)) -> Void {
        let params = ["offset": "\(offset)",
            "limit": "\(limit)"]
        let token = UserDefaults().string(forKey: "token") ?? ""
        
        Alamofire.request(Router.getPulses().path, method: Router.getPulses().method, parameters: params, encoding: URLEncoding.queryString, headers: [ "Authorization" : "Bearer \(token)" ])
            .validate()
            .responseArray { (alamoResponse: DataResponse<[Activity]>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    // TODO : Verifier les type de retour
    static func getPulsesToday(completed: @escaping ((_ response:[Pulse]?, _ error:Error?) -> Void)) -> Void {
        Alamofire.request(Router.getPulsesToday())
            .validate()
            .responseArray { (alamoResponse: DataResponse<[Pulse]>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func getPulsesLast(completed: @escaping ((_ response:Pulse?, _ error:Error?) -> Void)) -> Void {
        Alamofire.request(Router.getPulsesLast())
            .validate()
            .responseObject { (alamoResponse: DataResponse<Pulse>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func getPulsesIntervals(isTraining: Bool, completed: @escaping ((_ response:Interval?, _ error:Error?) -> Void)) -> Void {
        let params = ["isTraining": "\(isTraining)",
            "forceUpdate": "false"]
        let token = UserDefaults().string(forKey: "token") ?? ""
        
        Alamofire.request(Router.getPulsesIntervals().path, method: Router.getPulsesIntervals().method, parameters: params, encoding: URLEncoding.queryString, headers: [ "Authorization" : "Bearer \(token)" ])
            .validate()
            .responseObject { (alamoResponse: DataResponse<Interval>) in
                completed(alamoResponse.result.value, alamoResponse.result.error)
        }
    }
    
    static func postPulses(pulses: [Pulse], completed: @escaping ((_ error:Error?) -> Void)) -> Void {
        var datas: [Parameters] = []
        pulses.forEach {
            datas.append([
                "user_id": $0.user_id ?? 0,
                "isTraining": $0.isTraining ?? false,
                "bpm_avg": $0.bpm_avg ?? 0,
                "bpm_min": $0.bpm_min ?? 0,
                "bpm_max": $0.bpm_max ?? 0,
                "nb_steps": $0.nb_steps ?? 0,
                "date_min": $0.date_min ?? Date(),
                "date_max": $0.date_max ?? Date()
                ])
        }
        
        let parameters: Parameters = [
            "items": datas
        ]
        
        let token = UserDefaults().string(forKey: "token") ?? ""
        
        Alamofire.request(Router.postPulses().path, method: Router.postPulses().method, parameters: parameters, encoding: JSONEncoding.default, headers: [ "Authorization" : "Bearer \(token)" ])
            .validate()
            .response(completionHandler: { (alamoResponse) in
                completed(alamoResponse.error)
            })
    }
}
