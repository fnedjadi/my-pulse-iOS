//
//  HRViewController.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 01/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import GPUImage
#if targetEnvironment(simulator)
#else
import HeartRateKit
#endif
import HealthKit

class HRViewController: UIViewController {

    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var currentHeartRateLabel: UILabel!
    @IBOutlet weak var loadingView: CircleProgressView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    #if targetEnvironment(simulator)
    override func viewDidLoad() {
    }
    @IBAction func buttonAction(_ sender: UIButton) {
    }
    #else
    
    var isStarted = false
    var healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        numberSample = 15
        renderView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isStarted {
            stopMeasure()
//            HeartRateKit.HeartRateMonitor().stop()
            isStarted = !isStarted
        }
    }
    
    @objc func setView() {
        currentHeartRateLabel.text = ""
        startButton.setTitle("Start", for: .normal)
        stateLabel.text = "Not measuring"
        loadingView.progress = 0
    }
    
    func configureView() {
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
        backgroundView.layer.borderColor = #colorLiteral(red: 0, green: 0.1058823529, blue: 0.2235294118, alpha: 1)
        backgroundView.layer.borderWidth = 1.0
        loadingView.layer.masksToBounds = true
        loadingView.layer.cornerRadius = loadingView.bounds.height / 2
        loadingView.layer.borderColor = #colorLiteral(red: 0, green: 0.1058823529, blue: 0.2235294118, alpha: 1)
        loadingView.layer.borderWidth = 1.0
    }
    
    func stateLabel(_ state: UserState) -> String {
        if state == .noFinger {
            return "Place your finger"
        }
        else {
            return "Measuring"
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if !isStarted {
            startButton.setTitle("Stop", for: .normal)
            isStarted = true
            start(renderView: renderView, state: { (res) in
                DispatchQueue.main.async {
                    self.stateLabel.text = self.stateLabel(res.userState!)
                    self.loadingView.progress = Double((res.samples?.count)!) / Double(numberSample)
                    if let arr = res.samples, (arr.count > 0) {
                        self.currentHeartRateLabel.text = "\(Int(arr.map({$0}).reduce(0, +)) / arr.count)"
                    }
                }
            }) { (result) in
                DispatchQueue.main.async {
                    self.currentHeartRateLabel.text = "\(result)"
                    self.loadingView.progress = 1
                    stopMeasure()
                    self.showAlert(result)
                }
            }
        }
        else {
            startButton.setTitle("Start", for: .normal)
            stopMeasure()
            isStarted = false
            setView()
        }
    }
    
    func showAlert(_ heartRate: Int) {
        let alertController = UIAlertController(title: "Your heart beat is \(heartRate)!", message: "We will add it to your profile.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.setView()
            self.save(heartRate: heartRate)
        })
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func save(heartRate value: Int) -> Void
    {
        let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: Double(value))
        let heartRate : HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let date = Date()
        let heartRateSample: HKQuantitySample = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, start: date, end: date)
        
        self.healthStore.save(heartRateSample) { (success, error) in
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
    #endif
}
