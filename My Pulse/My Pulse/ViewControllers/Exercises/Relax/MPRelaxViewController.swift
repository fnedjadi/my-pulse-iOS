//
//  MPRelaxViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 20/06/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import AVFoundation
import HealthKit

class MPRelaxViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer?
    var played = false
    var timeMediation = 0.0
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "relax", ofType: "mp3") {
            let audiourl = NSURL.fileURL(withPath: path)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOf: audiourl)
                if let player = audioPlayer {
                    player.prepareToPlay()
                }
            } catch _ as NSError {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = audioPlayer {
            player.stop()
            timeMediation += player.currentTime
        }
        self.saveMindfullAnalysis()
    }
    
    @IBAction func play(_ sender: UIButton) {
        if let player = audioPlayer {
            if self.played {
                self.played = false
                sender.setImage(UIImage(named: "play"), for: .normal)
                player.pause()
            } else {
                self.played = true
                sender.setImage(UIImage(named: "pause"), for: .normal)
                player.play()
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timeMediation += player.currentTime
    }
    
    func saveMindfullAnalysis() {
        guard let mediationType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {return}
        let startDate = Date()
        let endDate = Date().addingTimeInterval(timeMediation)
        let mindfullSample = HKCategorySample(type:mediationType, value: 0, start: startDate, end: endDate)
        
        healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
            if error != nil {return}
        })
    }

}
