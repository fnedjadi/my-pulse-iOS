//
//  StandTestViewController.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import GPUImage
#if targetEnvironment(simulator)
#else
import HeartRateKit
#endif

class StandTestViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var currentHeartRateLabel: UILabel!
    @IBOutlet weak var loadingView: CircleProgressView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var indicationTitleLabel: UILabel!
    @IBOutlet weak var indicationSubtitleLabel: UILabel!
    
    @IBOutlet weak var indicationImageView: UIImageView!

    #if targetEnvironment(simulator)
    override func viewDidLoad() {
    }
    #else

    var isStarted = false
    
    var testNo = 0
    
    var sitDatas = [Double]()
    var standDatas = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        numberSample = 15
        renderView.isHidden = true
//        HeartRateMonitor.numberSample = 15
        measure()
        indicationConfiguration(shouldStand: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setView()
        if !isStarted {
            self.navigationController?.popViewController(animated: true)
        }
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
    
    func indicationConfiguration(shouldStand: Bool) {
        if shouldStand {
            indicationTitleLabel.text = "levez-vous".uppercased()
            indicationSubtitleLabel.text = "Veuillez vous lever en gardant votre doigt sur la camera."
            indicationImageView.image = #imageLiteral(resourceName: "stand-up")
        }
        else {
            indicationTitleLabel.text = "asseyez-vous".uppercased()
            indicationSubtitleLabel.text = "Installez-vous confortablement et relaxez vous."
            indicationImageView.image = #imageLiteral(resourceName: "sit-down")
        }
    }
    
    func measure() {
        if !isStarted {
            isStarted = true
            start(renderView: renderView, state: { (res) in
                DispatchQueue.main.async {
                    self.stateLabel.text = self.stateLabel(res.userState!)
                    self.loadingView.progress = Double((res.samples?.count)!) / Double(numberSample)
                    if let arr = res.samples, (arr.count > 0) {
                        self.currentHeartRateLabel.text = "\(Int(arr.map({$0}).reduce(0, +)) / arr.count)"
                    }
                    if self.testNo == 0 && res.samples?.count == numberSample - 1 {
                        self.sitDatas = res.samples!
                    }
                    else if self.testNo == 1 && res.samples?.count == numberSample - 1 {
                        self.standDatas = res.samples!
                    }
                }
            }) { (result) in
                DispatchQueue.main.async {
                    self.currentHeartRateLabel.text = "\(result)"
                    self.loadingView.progress = 1
                    if self.testNo == 0 {
                        self.testNo = 1
                        stopMeasure()
                        self.isStarted = false
                        self.indicationConfiguration(shouldStand: true)
                        self.measure()
                    }
                    else {
                        stopMeasure()
                        print(self.sitDatas)
                        print(self.standDatas)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "StandResultViewController") as! StandResultViewController
                        vc.sitDatas = self.sitDatas
                        vc.standDatas = self.standDatas
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                }
            }
        }
        else {
            stopMeasure()
//            HeartRateKit.HeartRateMonitor().stop()
            isStarted = false
            setView()
        }
    }
    #endif
}
