//
//  MPSignupViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 08/04/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import Alamofire

class MPSignupViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var familyNameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Notification
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.dismissKeyboard()
        let surname = self.familyNameField.text ?? ""
        let name = self.nameField.text ?? ""
        let email = self.emailField.text ?? ""
        let pwd = self.passwordField.text ?? ""
        
        BusinessManager.postUser(email: email, password: pwd, name: name, surname: surname) { (res, error) in
            if let _ = error as? AFError {
                let alert = UIAlertController(title: "Champ incomplet", message: "Merci de remplir toutes les informations demandées.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension MPSignupViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == familyNameField) {
            self.nameField.becomeFirstResponder()
        } else if (textField == nameField) {
            self.emailField.becomeFirstResponder()
        } else if (textField == emailField) {
            self.passwordField.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
            self.signUpAction(textField)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField

        if textField == familyNameField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if textField == nameField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        else if textField == emailField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        else if textField == passwordField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldDismissKeyboard() {
        view.endEditing(true)
    }
    
}
