//
//  BusinessManagerPulses.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 05/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import Alamofire

extension BusinessManager {
    
    static func getPulses(offset: Int, limit: Int, date: Date?, completed: @escaping ((_ response:[Activity]?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getPulses(offset: offset, limit: limit, date: date) { (res, err) in
            completed(res, err)
        }
    }
    
    static func getPulsesToday(completed: @escaping ((_ response:[Pulse]?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getPulsesToday { (res, err) in
            completed(res, err)
        }
    }
    
    static func getPulsesLast(completed: @escaping ((_ response:Pulse?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getPulsesLast { (res, err) in
            completed(res, err)
        }
    }
    
    static func getPulsesIntervals(isTraining: Bool, completed: @escaping ((_ response:Interval?, _ error:Error?) -> Void)) -> Void {
        DataAccess.getPulsesIntervals(isTraining: isTraining) { (res, err) in
            completed(res, err)
        }
    }
    
    static func postPulses(pulses: [Pulse], completed: @escaping ((_ error:Error?) -> Void)) -> Void {
        DataAccess.postPulses(pulses: pulses) { (err) in
            completed(err)
        }
    }
}
