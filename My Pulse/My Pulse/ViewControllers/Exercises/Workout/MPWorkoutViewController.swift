//
//  MPWorkoutViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 12/09/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import WebKit

class MPWorkoutViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myURL = URL(string:"https://www.youtube.com/user/lesmillsgroupfitness/videos") {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
