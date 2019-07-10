//
//  MPFormViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 30/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class MPFormViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        MPActivitiesManager.sharedInstance.start()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainStoryboard")
        self.present(vc, animated: false, completion: nil)
    }
}
