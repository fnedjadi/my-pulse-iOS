//
//  StandResultViewController.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class StandResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sitDatas = [Double]()
    var standDatas = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension StandResultViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension StandResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 49.0
        case 1:
            return 100.0
        case 2:
            return 57.0
        case 3:
            return 57.0
        case 4:
            return 57.0
        case 5:
            return 73.0
        default:
            return 100.0
        }
    }
    
    func average(_ array: [Double]) -> Int {
        let total = array.reduce(0, +) - array.max()! - array.min()!
        let avg = total / Double(array.count)
        return Int(round(avg))
    }
    
    func max(_ array: [Double]) -> Int {
        if array.count > 0 {
            return Int(round(array.max()!))
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandDateCell", for: indexPath) as! StandDateCell
            cell.configure()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandResultCell", for: indexPath) as! StandResultCell
            cell.sitDataAVG = average(self.sitDatas)
            cell.standDataAVG = average(self.standDatas)
            cell.configure()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandBeatCell", for: indexPath) as! StandBeatCell
            cell.configure(title: "assis", heartRate: average(sitDatas))
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandBeatCell", for: indexPath) as! StandBeatCell
            cell.configure(title: "pic", heartRate: max(standDatas))
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandBeatCell", for: indexPath) as! StandBeatCell
            cell.configure(title: "debout", heartRate: average(standDatas))
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            return cell
        }
    }
}
