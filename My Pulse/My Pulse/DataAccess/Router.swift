//
//  Router.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol RouterProtocol {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
}

enum Router {
    case getUsers()
    case getQuestions()
    case postLogin()
    case postUser()
    case postAnswers()
    case putUser()
    
    case getPulses()
    case getPulsesToday()
    case getPulsesLast()
    case getPulsesIntervals()
    case postPulses()
}

extension Router : RouterProtocol {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        case .postLogin:
            return .post
        case .postUser:
            return .post
        case .getQuestions:
            return .get
        case .postAnswers:
            return .post
        case .putUser:
            return .put
            
        case .getPulses:
            return .get
        case .getPulsesToday:
            return .get
        case .getPulsesLast:
            return .get
        case .getPulsesIntervals:
            return .get
        case .postPulses:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS + "?api_key=" + Constants.Headers.Api_Key
        case .postLogin:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS + Constants.Url.LOGIN + "?api_key=" + Constants.Headers.Api_Key
        case .postUser:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS + "?api_key=" + Constants.Headers.Api_Key
        case .getQuestions:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS + Constants.Url.QUESTIONS
        case .postAnswers:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS + Constants.Url.ANSWERS
        case .putUser:
            return Constants.Url.ENTRY_API_URL + Constants.Url.USERS
            
        case .getPulses:
            return Constants.Url.ENTRY_API_URL + Constants.Url.PULSES
        case .getPulsesToday:
            return Constants.Url.ENTRY_API_URL + Constants.Url.PULSES + Constants.Url.TODAY
        case .getPulsesLast:
            return Constants.Url.ENTRY_API_URL + Constants.Url.PULSES + Constants.Url.LAST
        case .getPulsesIntervals:
            return Constants.Url.ENTRY_API_URL + Constants.Url.PULSES + Constants.Url.INTERVALS
        case .postPulses:
            return Constants.Url.ENTRY_API_URL + Constants.Url.PULSES
        }
    }
    
    fileprivate var headers: HTTPHeaders {
        return Constants.Headers.headers
    }
}

extension Router: URLRequestConvertible {
    public func asURLRequest () -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: self.path)!)
        urlRequest.httpMethod = self.method.rawValue
        if let tokenString = UserDefaults().string(forKey: "token") {
            urlRequest.setValue("Bearer \(tokenString)", forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
