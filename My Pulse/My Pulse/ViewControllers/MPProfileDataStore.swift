//
//  MPProfileDataStore.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 11/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import HealthKit

class MPProfileDataStore : NSObject{
    
    let hkStore = HKHealthStore()
    
    func getBirthDate() -> Date? {
        do {
            let birthdayComponents =  try hkStore.dateOfBirthComponents()
            return birthdayComponents.date
        } catch _ {
            return nil
        }
    }
    
    func getAge() -> Int? {
        do {
            let birthdayComponents =  try hkStore.dateOfBirthComponents()
            let calendar = Calendar.current
            
            let todayDateComponents = calendar.dateComponents([.month, .year], from: Date())
            
            let thisYear = todayDateComponents.year
            let thisMonth = todayDateComponents.month
            
            let bdYear = birthdayComponents.year
            let bdMonth = birthdayComponents.month
            
            let age = thisYear! - bdYear! - (thisMonth! < bdMonth! ? 1 : 0)
            
            return age
        } catch _ {
            return nil
        }
    }
    
    func getBiologicalSexType() -> HKBiologicalSex? {
        do {
            let biologicalSex =  try hkStore.biologicalSex()
            return biologicalSex.biologicalSex
        } catch _ {
            return nil
        }
    }
    
    func getHeight(completion: @escaping (HKQuantity?, Error?) -> Swift.Void) {
        
        guard let heightType = HKSampleType.quantityType(forIdentifier: .height) else {
            completion(nil, NSError.init())
            return
        }
        self.getMostRecentSample(for: heightType) { (sample, error) in
            completion(sample?.quantity, error)
        }
    }
    
    func getWeight(completion: @escaping (HKQuantity?, Error?) -> Swift.Void) {
        
        guard let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            completion(nil, NSError.init())
            return
        }
        self.getMostRecentSample(for: weightType) { (sample, error) in
            completion(sample?.quantity, error)
        }
    }
    
    private func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples,
                                                    let mostRecentSample = samples.first as? HKQuantitySample else {
                                                        
                                                        completion(nil, error)
                                                        return
                                                }
                                                
                                                completion(mostRecentSample, nil)
                                            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}

extension HKBiologicalSex {
    var stringRepresentation : String {
        switch self {
        case .female: // 1
            return "Female"
        case .male: // 2
            return "Male"
        case .other: // 3
            return "Other"
        case .notSet: // 0
            return ""
        }
    }
    
}
