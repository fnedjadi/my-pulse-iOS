//
//  Utils.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 31/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

public class Utils {
    static func getAge() -> String {
        let age = MPProfileDataStore().getAge() ?? 0
        return age > 0 ? "\(age)": ""
    }

    static func getSexe() -> String {
        if let sex = UserDefaults().string(forKey: "sex") {
            return sex
        } else {
            let sex = MPProfileDataStore().getBiologicalSexType() ?? HKBiologicalSex.notSet
            return sex.stringRepresentation
        }
    }

    static func getHeight() -> String {
        if let height = UserDefaults().string(forKey: "height") {
            return height
        } else {
            MPProfileDataStore().getHeight { (res, error) in
                if let quantity = res {
                    let cm = quantity.doubleValue(for: HKUnit.meter())*100
                    UserDefaults().set("\(Int(cm))", forKey: "height")
                }
            }
        }
        
        return ""
    }

    static func getWeight() -> String {
        if let weight = UserDefaults().string(forKey: "weight") {
            return weight
        } else {
            MPProfileDataStore().getWeight { (res, error) in
                if let quantity = res {
                    let kg = quantity.doubleValue(for: .gram())/1000
                    UserDefaults().set("\(Int(kg))", forKey: "weight")
                }
            }
        }
        return ""
    }

    static func getEmail() -> String {
        return UserDefaults().string(forKey: "user_email") ?? ""
    }

    static func getName() -> String {
        return UserDefaults().string(forKey: "user_name") ?? ""
    }

    static func getSurname() -> String {
        return UserDefaults().string(forKey: "user_surname") ?? ""
    }

    static func getFullName() -> String {
        if let name = UserDefaults().string(forKey: "user_name") {
            if let surname = UserDefaults().string(forKey: "user_surname") {
                return name + " " + surname
            }
        }
        return UserDefaults().string(forKey: "user_surname") ?? ""
    }
    
    static func colorBpm(value : Int) -> UIColor {
//        let min = UserDefaults().string(forKey: "bpm_min")
//        let max = UserDefaults().string(forKey: "bpm_max")
        
        if value < 79 && value > 58 {
            return UIColor(red:0.30, green:0.85, blue:0.00, alpha:1.0)
        }
        //else if value < 120 {
          //  return UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
        //}
        else {
            return UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
        }
    }
    static func colorBpmTransparent(value : Int) -> UIColor {
//        let min = UserDefaults().string(forKey: "bpm_min")
//        let max = UserDefaults().string(forKey: "bpm_max")

        if value < 79 && value > 58 {
            return UIColor(red:0.30, green:0.85, blue:0.00, alpha:0.4)
        }
//        else if value < 120 {
//            return UIColor(red:1.00, green:0.80, blue:0.00, alpha:0.4)
//        }
        else {
            return UIColor(red:1.00, green:0.23, blue:0.19, alpha:0.4)
        }
    }
    
    static func textBpm(value : Int) -> String {
//        let min = UserDefaults().string(forKey: "bpm_min")
//        let max = UserDefaults().string(forKey: "bpm_max")

        if value < 79 && value > 58 {
            return "Activité normale"
        }
//        else if value < 120 {
//            return "Activité à surveiller"
//        }
        else {
            return"Activité anormale"
        }
    }
    
    static func saveFromAnswers(_ answers: [Answers]) {
        for ans in answers {
            switch ans.profile_questions_id {
            case 2 :
                UserDefaults().set(ans.answer, forKey: "weight")
                break
            case 3 :
                UserDefaults().set(ans.answer, forKey: "sex")
                break
            case 5 :
                UserDefaults().set(ans.answer, forKey: "height")
                break
            default:
                break
            }
        }
    }
    
    static func saveProfil(user: User) {
        self.cleanUserDefaults(withToken: false)
        UserDefaults().set(user.id, forKey: "user_id")
        UserDefaults().set(user.email, forKey: "user_email")
        UserDefaults().set(user.name, forKey: "user_name")
        UserDefaults().set(user.surname, forKey: "user_surname")
        // TODO: UserDefaults().set(user.answers, forKey: "user_answers")
    }
    
    static func cleanUserDefaults(withToken : Bool) {
        if withToken {
            UserDefaults().removeObject(forKey: "token")
        }
        UserDefaults().removeObject(forKey: "user_id")
        UserDefaults().removeObject(forKey: "user_email")
        UserDefaults().removeObject(forKey: "user_name")
        UserDefaults().removeObject(forKey: "user_surname")
        UserDefaults().removeObject(forKey: "user_answers")
        UserDefaults().removeObject(forKey: "dateStr")
    }

    func save(heartRate value: Int) -> Void {
        let healthStore = HKHealthStore()
        let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: Double(value))
        let heartRate : HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let date = Date()
        let heartRateSample: HKQuantitySample = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, start: date, end: date)
        
        healthStore.save(heartRateSample) { (success, error) in
            if !success {
                abort()
            } else {
                var pulses : [Pulse] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                let dateStr = dateFormatter.string(from: date)
                let pulse = Pulse.init(isTraining: false,
                                       bpm_avg: value,
                                       bpm_min: value,
                                       bpm_max: value,
                                       nb_steps: 0,
                                       date_min: "\(dateStr)",
                    date_max: "\(dateStr)",
                    source: "My Pulse"
                )
                pulses.append(pulse)
                
                BusinessManager.postPulses(pulses: pulses) { (err) in
                    if let _ = err {
                        print("Error from post pulses")
                    }
                }
            }
        }
    }
}
