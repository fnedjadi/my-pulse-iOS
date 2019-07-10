//
//  MPDataViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 31/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import Alamofire

class MPDataViewController: UIViewController {

    var data : [Activity] = []
    var time = 1
    var limit = 325
    var offset = 0
    var isLoadingMore = false
    
    @IBOutlet weak var dataTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataTableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isLoadingMore = false
        handleRefresh(nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl?) {
        self.isLoadingMore = false
        BusinessManager.getPulses(offset: self.offset, limit: self.limit, date: nil) { (activities, err) in
            if let _ = err {
                return
            } else {
                if let datas = activities {
                    self.data = datas.reversed()
                    self.dataTableView.reloadData()
                    if let _ = refreshControl {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
            self.isLoadingMore = false
        }
    }
}

extension MPDataViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dataTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? MPDataTableViewCell else {return UITableViewCell()}
        
        if let value = data[indexPath.row].avg {
            cell.heartRateLabel.text = "\(value)"
            cell.drawCircle(forvalue: value)
        }
        if let max = data[indexPath.row].max {
            cell.maxLabel.text = "\(max)"
        }
        if let min = data[indexPath.row].min {
            cell.minLabel.text = "\(min)"
        }
        if let date = data[indexPath.row].date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let tmp = dateFormatter.date(from: date) {
                cell.dateLabel.text = DateFormatter.localizedString(from: tmp, dateStyle: .medium, timeStyle: .none)
            } else {
                cell.dateLabel.text = date
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
