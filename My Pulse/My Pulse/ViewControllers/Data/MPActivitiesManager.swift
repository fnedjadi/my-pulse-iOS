//
//  MPActivitiesManager.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 08/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import HealthKit

class MPActivitiesManager {
    
    static let sharedInstance = MPActivitiesManager()
    
    let hkManager = MPHealthKitManager.sharedInstance
    var datas : [HKQuantitySample] = []
    var heartRateQuery : HKQuery?
    
    func start() {
        hkManager.authorizeHealthkit { (success, error) in
            print("HealthKit connected: \(success)")
            self.retrieveHeartRateData()
        }
    }
    
    func retrieveHeartRateData() {
        var startDate = Date().addingTimeInterval(-3600*24*14)
        if let dateStr = UserDefaults().string(forKey: "dateStr") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let date = dateFormatter.date(from: dateStr) ?? startDate
            startDate = date
        }
        
        let endDate = Date()
        if let query = hkManager.createHeartRateStreaming(startDate: startDate, endDate: endDate) {
            self.heartRateQuery = query
            self.hkManager.heartRateDelegate = self
            self.hkManager.healthStore.execute(query)
        }
    }
    
    func removeExtra(_ quantity : HKQuantity) -> Int {
        let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let res = quantity.doubleValue(for: unit)
        return Int(res)
    }
    
    func pushNewDatas() {
        var pulses : [Pulse] = []
        var i = 0
        while i < self.datas.count  {
            let source = datas[i].sourceRevision.source.name
            var avg = removeExtra(datas[i].quantity)
            var min = removeExtra(datas[i].quantity)
            var max = removeExtra(datas[i].quantity)
            let startDate = datas[i].startDate
            var endDate = datas[i].endDate
            var count = 1
            i += 1
            while i < self.datas.count && datas[i].endDate < startDate.addingTimeInterval(3600) {
                let bpm = removeExtra(datas[i].quantity)
                if min > bpm {
                    min = bpm
                } else if max < bpm {
                    max = bpm
                }
                avg += bpm
                endDate = datas[i].endDate
                i += 1
                count += 1
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let startDateStr = dateFormatter.string(from: startDate)
            let endDateStr = dateFormatter.string(from: endDate)
            let pulse = Pulse.init(isTraining: false,
                                   bpm_avg: avg/count,
                                   bpm_min: min,
                                   bpm_max: max,
                                   nb_steps: 0,
                                   date_min: "\(startDateStr)",
                                   date_max: "\(endDateStr)",
                                   source: "\(source)")
            pulses.append(pulse)
        }
        
        BusinessManager.postPulses(pulses: pulses) { (err) in
            if let _ = err {
                print("Error from post pulses")
            }
        }
    }
}

extension MPActivitiesManager : MPHeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample]) {
        guard let samples = heartRateSamples as? [HKQuantitySample] else {
            return
        }
        DispatchQueue.main.async {
            self.datas = samples.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
            self.pushNewDatas()
        }
    }
}
