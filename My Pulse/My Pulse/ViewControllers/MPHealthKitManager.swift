//
//  MPHealthKitManager.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 27/02/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import HealthKit

protocol MPHeartRateDelegate {
    func heartRateUpdated(heartRateSamples : [HKSample])
}

class MPHealthKitManager: NSObject {
    
    static let sharedInstance = MPHealthKitManager()
    
    let healthStore = HKHealthStore()
    
    var anchor : HKQueryAnchor?
    
    var heartRateDelegate : MPHeartRateDelegate?
    
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func authorizeHealthkit(_ completion: @escaping ((_ success: Bool, _ error: Error?)->Void)) {
        
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier : .heartRate),
            let heightType = HKQuantityType.quantityType(forIdentifier : .height),
            let weightType = HKQuantityType.quantityType(forIdentifier : .bodyMass),
            let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let mediationType = HKObjectType.categoryType(forIdentifier: .mindfulSession),
            let ageType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let stepType = HKQuantityType.quantityType(forIdentifier : .stepCount),
            let distanceType = HKQuantityType.quantityType(forIdentifier : .distanceWalkingRunning) else {return}
        
        let toShare = Set([heartRateType, mediationType])
        let toRead = Set([ageType, biologicalSexType, heightType, weightType, heartRateType, stepType, distanceType, mediationType])
        
        healthStore.requestAuthorization(toShare: toShare, read: toRead) { (success, error) in
            completion(success, error)
        }
    }
    
    
    func createHeartRateStreaming(startDate : Date?, endDate : Date?) -> HKQuery? {
        
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier : .heartRate) else {return nil}
        var compoundPredicate : NSCompoundPredicate? = nil
        if let date = startDate {
            let datePredicate = HKQuery.predicateForSamples(withStart: date, end: endDate, options: .strictEndDate)
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate])
        }
        let limit = Int(HKObjectQueryNoLimit)
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: compoundPredicate, anchor: nil, limit: limit) { (query, sampleObjects, deletedObjects, queryAnchor, error) in
            guard let newAnchor = queryAnchor, let sampleObjects = sampleObjects else {return}
            self.anchor = newAnchor
            self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, sampleObjects, deletedObjects, queryAnchor, error) -> Void in
            guard let newAnchor = queryAnchor, let sampleObjects = sampleObjects else {return}
            self.anchor = newAnchor
            self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
        
        return heartRateQuery
    }
    
    func distanceWalkingRunning(completion: @escaping (Double, Error?) -> Void) {
        guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        let date =  Date()
        let startDate = Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: date)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            if let quantity = statistics?.sumQuantity() {
                value = quantity.doubleValue(for: HKUnit.meter())
            }
            DispatchQueue.main.async {
                completion(value, error)
            }
        }
        healthStore.execute(query)
    }
}
