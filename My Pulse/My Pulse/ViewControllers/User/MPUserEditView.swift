//
//  MPUserEditView.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 04/07/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import Alamofire

class MPUserEditView: UIView {
    
    static var `default` : MPUserEditView? = {
        return Bundle.main.loadNibNamed("UserEditView", owner: self, options: nil)?.first as? MPUserEditView
    }()
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var shown = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.addGestureRecognizer(tap)
        
        self.backgroundBlurView.effect = nil
        self.popUpView.layer.cornerRadius = 4
    }
    
    override func didMoveToSuperview() {
        surnameTextField.text = ""
        nameTextField.text = ""
        emailTextField.text = ""
        
        surnameTextField.placeholder = Utils.getSurname()
        nameTextField.placeholder = Utils.getName()
        emailTextField.placeholder = Utils.getEmail()
    }
    
    @objc public func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let name = (self.nameTextField.text == "") ? Utils.getName() : self.nameTextField.text
        let surname = (self.surnameTextField.text == "") ? Utils.getSurname() : self.surnameTextField.text
        let email = (self.emailTextField.text == "") ? Utils.getEmail() : self.emailTextField.text
        BusinessManager.putUser(email: email!, name: name!, surname: surname!, completed: { (res, error) in
            if let user = res {
                user.answers = UserDefaults().array(forKey: "user_answers") as? [Answers]
                Utils.saveProfil(user: user)
                self.dismissTheView()
            }
        })
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismissTheView()
    }
    
    func show() {
        if !shown {
            if let app = UIApplication.shared.delegate as? AppDelegate{
                if let window = app.window {
                    window.addSubview(self)
                    self.shown = true
                    self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    self.backgroundBlurView.effect = nil
                    self.popUpView.alpha = 0
                    UIView.animate(withDuration: 0.4, animations: {
                        self.backgroundBlurView.effect = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
                        self.popUpView.alpha = 1
                    })
                }
                
            }
        }
    }
    
    func dismissTheView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundBlurView.effect = nil
            self.popUpView.alpha = 0
        }){ (finished) in
            self.shown = false
            self.removeFromSuperview()
        }
    }
}
