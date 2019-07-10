//
//  MPLoginViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 08/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import Alamofire

class MPLoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        self.dismissKeyboard()
        let email = emailField.text ?? "";
        let pwd = passwordField.text ?? "";

        BusinessManager.postLogin(email: email, password: pwd) { (res, error) in
            if let err = error as? AFError {
                let title = err.responseCode == 401 ? "Champ incorrect" : "Champ manquant"
                let message = err.responseCode == 401 ? "Les informations entrées semblent être incorrectes. Merci de vérifier votre email et mot de passe puis réessayer." : ""
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else if let _ = error {
                return
            }
            UserDefaults().set(res?.token, forKey: "token")
            if let user = res?.user {
                Utils.saveProfil(user: user)
                Utils.saveFromAnswers(user.answers ?? [])
            }
            MPHealthKitManager.sharedInstance.authorizeHealthkit { (success, error) in
            }
            let completed = res?.user?.profileCompleted ?? false
            if completed {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "mainStoryboard")
                self.present(vc, animated: false, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Form", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "formStoryboard")
                self.present(vc, animated: false, completion: nil)
                
            }
        }
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MPLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailField) {
            self.passwordField.becomeFirstResponder()
        } else if (emailField.text != "" && passwordField.text != "") {
            self.dismissKeyboard()
            self.loginButton(textField)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        else if textField == passwordField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldDismissKeyboard() {
        view.endEditing(true)
    }
}
