//
//  MPHomeViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 21/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import Charts

class MPHomeViewController: UIViewController {

    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var additionnalBadgeView: UIView!
    @IBOutlet weak var additionnalBadgeViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lowerBackgroundView: UIView!
    @IBOutlet weak var currentBpmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var graphicView: LineChartView!
    
    var zooming = false
    var heartBeatInterval : TimeInterval = 1
    var currentBPM = 0
    var timer : Timer?
    
    var todayHours : [Int] = []
    var todayBpm : [Int] = []
    var todayMax = 40
    var todayMin = 200
    var lastToday = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.badgeView.layer.cornerRadius = self.additionnalBadgeView.bounds.height / 2
        self.additionnalBadgeView.layer.cornerRadius = self.additionnalBadgeView.bounds.height / 2
        self.getTodayPulses()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MPActivitiesManager.sharedInstance.start()
        self.getLastPulse()
        self.getTodayPulses()
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = Int(interval)
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        if hours > 0 {
            return String(format: "\(hours)h \(minutes)m")
        }
        return String(format: "\(minutes)m")
    }
    
    func getLastPulse() {
        BusinessManager.getPulsesLast { (pulse, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                if let bpm = pulse?.bpm_avg {
                    self.editLastBpm(value: bpm)
                }
                if let dateStr = pulse?.date_max {
                    UserDefaults().set(dateStr, forKey: "dateStr")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "fr_FR")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    var date = Date()
                    if let tmpDate = dateFormatter.date(from: dateStr) {
                        date = tmpDate
                    } else {
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        if let tmpDate = dateFormatter.date(from: dateStr) {
                            date = tmpDate
                        } else {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            if let tmpDate = dateFormatter.date(from: dateStr) {
                                date = tmpDate
                            }
                        }
                    }
                    let difference = Date().timeIntervalSince(date)
                    self.timeLabel.text = "\(self.stringFromTimeInterval(interval: difference))"
                }
                self.sourceLabel.text = "\(pulse?.source ?? "N/A")"
            }
        }
    }
    
    func editLastBpm(value : Int) {
        self.currentBPM = Int(value)
        self.heartBeatInterval = 60 / Double(self.currentBPM)
        self.currentBpmLabel.text = "\(self.currentBPM)"
        self.circleBadge()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: self.heartBeatInterval, target: self, selector: #selector(self.beatBadgeView), userInfo: nil, repeats: true)
    }
    
    func circleBadge() {
        self.badgeView.backgroundColor = Utils.colorBpm(value: self.currentBPM)
        self.additionnalBadgeView.backgroundColor = Utils.colorBpmTransparent(value: self.currentBPM)
    }
    
    @objc func beatBadgeView() {
        let newheigth = self.zooming ? self.topBackgroundView.frame.height - 10 : self.badgeView.frame.height
        zooming = !zooming
        
        UIView.animate(withDuration: self.heartBeatInterval) {
            self.additionnalBadgeViewHeightConstraint.constant = newheigth
            self.additionnalBadgeView.layer.cornerRadius = newheigth / 2
            self.view.layoutIfNeeded()
        }
    }
    
    func getTodayPulses() {
        BusinessManager.getPulsesToday { (res, err) in
            if let _ = err {
                print("Error from today pulses")
                return
            }
            if let pulses = res {
                if pulses.count > self.lastToday {
                    self.lastToday = pulses.count
                    for pulse in pulses {
                        if let bpm = pulse.bpm_avg {
                            if bpm < self.todayMin {
                                self.todayMin = bpm
                            }
                            if bpm > self.todayMax {
                                self.todayMax = bpm
                            }
                            self.todayBpm.append(bpm)
                            if let dateStr = pulse.date_min {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                if let date = dateFormatter.date(from: dateStr) {
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    self.todayHours.append(hour)
                                }
                            }
                            
                        }
                    }
                    self.setGraphicView()
                }
            }
        }
    }
}

extension MPHomeViewController : ChartViewDelegate {
    func setGraphicView() {
        let xAxis = graphicView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 20, weight: .bold)
        xAxis.labelTextColor = UIColor(red: 0/255, green: 27/255, blue: 57/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        
        let leftAxis = graphicView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 20, weight: .bold)
        leftAxis.labelTextColor = UIColor(red: 0/255, green: 27/255, blue: 57/255, alpha: 1)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = Double(self.todayMin - 10)
        leftAxis.axisMaximum = Double(self.todayMax + 10)
        
        graphicView.rightAxis.enabled = false
        
        self.setChart(datas: self.todayHours, values: self.todayBpm)
    }
    
    func setChart(datas : [Int], values : [Int]) {
        self.graphicView.delegate = self
        self.graphicView.chartDescription?.enabled = false
        self.graphicView.setScaleEnabled(false)
        self.graphicView.pinchZoomEnabled = false
        self.graphicView.legend.enabled = false
        
        var dataEntries : [ChartDataEntry] = []
        
        for i in 0..<datas.count {
            dataEntries.append(ChartDataEntry(x: Double(datas[i]), y: Double(values[i])))
        }
        
        let chartSet = LineChartDataSet(values: dataEntries, label: nil)
        chartSet.axisDependency = .left
        chartSet.setColor(UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1))
        chartSet.lineWidth = 5
        chartSet.drawCirclesEnabled = false
        chartSet.drawValuesEnabled = false
        chartSet.fillColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        chartSet.highlightColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        chartSet.drawCircleHoleEnabled = false
        
        let chartData = LineChartData(dataSets: [chartSet])
        self.graphicView.data = chartData
        
        for set in graphicView.data!.dataSets as! [LineChartDataSet] {
            set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
        }
        
        graphicView.setNeedsDisplay()
    }
}
