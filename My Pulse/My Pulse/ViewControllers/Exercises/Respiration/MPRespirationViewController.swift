//
//  MPRespirationViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 18/06/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import GPUImage
import AudioToolbox.AudioServices
#if targetEnvironment(simulator)
#else
 import HeartRateKit
#endif

class MPRespirationViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var backgroungCircleView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleLabel: UILabel!
    
    
    @IBOutlet weak var cirecleViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    #if targetEnvironment(simulator)
    override func viewDidLoad() {
    }
    #else
    
    var lightBlue = UIColor(red:0.35, green:0.78, blue:0.98, alpha:0.64)
    var purple = UIColor(red:0.24, green:0.00, blue:0.76, alpha:0.64)
    var zooming = true
    var circleInterval : TimeInterval = 3
    var activated = true
    
    var isStarted = false
    var datas = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderView.isHidden = true

        self.circleView.layer.cornerRadius = self.circleView.frame.height / 2
        self.activated = true
        self.circleBeatView()
        self.stateLabel.text = "Not measuring"
        numberSample = 15
        self.measure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isStarted {
            stopMeasure()
            isStarted = !isStarted
        }
        self.activated = false
    }
    
    @objc func circleBeatView() {
        self.circleInterval = zooming ? 6 : 3
        AudioServicesPlaySystemSound(1352)
        let newheigth = self.zooming ? self.backgroungCircleView.frame.height - 10 : 100
        let color = self.zooming ? self.lightBlue : self.purple
        self.timeLabel.text = "\(Int(self.circleInterval))s restantes"
        self.circleLabel.text = self.zooming ? "Expirez" : "Inspirez"
        self.zooming = !self.zooming
        
        UIView.animate(withDuration: self.circleInterval, animations: {
            self.cirecleViewHeightConstraint.constant = newheigth
            self.circleView.layer.cornerRadius = newheigth / 2
            self.circleView.backgroundColor = color
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished && self.activated {
                self.circleBeatView()
            }
        }
    }
    
    func stateLabel(_ state: UserState) -> String {
        if state == .noFinger {
            return "Placez votre doigt"
        }
        else {
            return "Measuring..."
        }
    }
    
    func measure() {
        if !self.isStarted {
            self.isStarted = true
            start(renderView: renderView, state: { (res) in
                DispatchQueue.main.async {
                    self.stateLabel.text = self.stateLabel(res.userState!)
                    if res.samples?.count == numberSample - 1 {
                        self.datas = res.samples!
                    }
                }
            }) { (result) in
                DispatchQueue.main.async {
                    self.activated = false
                    stopMeasure()
                    let alert = UIAlertController(title: "Fin.", message: "Vous avez fini l'exercice ! Votre battement cardiaque a été en moyenne de \(result)bpm.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                    Utils().save(heartRate: result)
                }
            }
        }
        else {
            stopMeasure()
            self.isStarted = false
        }
    }
 
    #endif
}
