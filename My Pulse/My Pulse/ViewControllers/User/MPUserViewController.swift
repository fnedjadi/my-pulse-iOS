//
//  MPUserViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 31/03/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit
import WebKit

class MPUserViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let leftField = ["Email", "Poids", "Taille", "Age", "Sexe", "Unité", "Questionnaire" ,"Politique de protection des données" ,"Se déconnecter"]
    var rightField = [Utils.getEmail(), Utils.getWeight(), Utils.getHeight(), Utils.getAge(), Utils.getSexe(), "Metric", "", "", ""]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = Utils.getFullName()
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDefaultsChange(notification:)), name: UserDefaults.didChangeNotification, object: nil)
        BusinessManager.getUsers { (res, err) in
            if let user = res {
                if let answers = user.answers {
                    Utils.saveFromAnswers(answers)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func userDefaultsChange(notification : Notification) {
        self.nameLabel.text = Utils.getFullName()
        self.settingTableView.reloadData()
    }
    
    func formAction() {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "formStoryboard")
        self.present(vc, animated: false, completion: nil)
    }
    
    func logoutAction() {
        Utils.cleanUserDefaults(withToken: true)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginStoryboard")
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        guard let popUp = MPUserEditView.default else {
            return
        }
        popUp.show()
    }
}

extension MPUserViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personnel"
        case 1:
            return "Application"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? MPUserTableViewCell else {return UITableViewCell()}
        var i = indexPath.row
        switch indexPath.section {
        case 1:
            i += 5
        case 2:
            i += 6
            cell.leftLabel.textColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
            cell.backgroundColor = UIColor.white
        default:
            break
        }
        cell.leftLabel.text = leftField[i]
        cell.rightLabel.text = self.rightField[i]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 55
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                self.formAction()
            } else if indexPath.row == 2 {
                let alert = UIAlertController(title: "Êtes-vous sûr·e de vouloir vous déconnecter ?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Se déconnecter", style: .destructive, handler: { _ in
                    self.logoutAction()
                }))
                alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let vc = MPUserPrivacyViewController()
                self.navigationController?.show(vc, sender: self)
            }
        }
    }
}
