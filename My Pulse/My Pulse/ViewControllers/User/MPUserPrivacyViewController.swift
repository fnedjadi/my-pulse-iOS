//
//  MPUserPrivacyViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 28/11/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import WebKit

class MPUserPrivacyViewController: UIViewController, WKUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webview = WKWebView()
        webview.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let myURL = URL(string:"https://mypulse.eu/personal-protection-policy") {
            let myRequest = URLRequest(url: myURL)
            webview.load(myRequest)
        }
        webview.uiDelegate = self
        self.view.addSubview(webview)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
