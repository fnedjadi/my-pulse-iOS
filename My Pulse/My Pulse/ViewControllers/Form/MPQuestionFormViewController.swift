//
//  MPQuestionFormViewController.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 10/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MPQuestionFormViewController: UIViewController {

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var amountQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    
    var questions : [Questions]?
    var amount : Int?
    var profile_questions_id : Int?
    var question = 0
    
    var dataPicker : [String]?
    var answers : [String]?
    var resultAnswers : [Answers] = []
    var curResultAnswer : Answers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.progressViewWidthConstraint.constant = self.questionView.frame.width
        
        BusinessManager.getQuestions { (questions, error) in
            if let _ = error as? AFError {
                let alert = UIAlertController(title: "Erreur.", message: "Une erreur est survenu lors du chargement des questions. Merci de remplir le formulair plus tard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mainStoryboard")
                    self.present(vc, animated: false, completion: nil)
                }))
                self.present(alert, animated: true)
                return
            }
            if let questions = questions {
                self.amountQuestionLabel.text = "\(questions.count)"
                self.amount = questions.count
                self.questions = questions
                self.setQuestion(number: self.question)
            }
        }
        // TODO : handle error
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let amount = self.amount else {
            // TODO : handle error
            return
        }
        
        question += 1
        if question < amount {
            self.responseView.subviews.forEach({ $0.removeFromSuperview() })
            self.resultAnswers.append(curResultAnswer ?? Answers(profile_questions_id: self.profile_questions_id ?? -1, answer : ""))
            setQuestion(number: question)
        } else {
            self.resultAnswers.append(curResultAnswer ?? Answers(profile_questions_id: self.profile_questions_id ?? -1, answer : ""))
            BusinessManager.postAnswers(answers: self.resultAnswers) { (res, error) in
                if let _ = error as? AFError {
                    let alert = UIAlertController(title: "Erreur.", message: "Une erreur est survenu lors du chargement des questions. Merci de remplir le formulair plus tard.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                    return
                } else {
                    let alert = UIAlertController(title: "Fin.", message: "Merci d'avoir pris le temps de completer ce questionnaire. Vous pouvez maintenant accéder à l'application", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "mainStoryboard")
                        self.present(vc, animated: false, completion: nil)
                    }))
                    self.present(alert, animated: true)
                    Utils.saveFromAnswers(res ?? [])
                    MPActivitiesManager.sharedInstance.start()
                }
            }
        }
    }
    
    func parseAnswerType(_ type : String) {
        var minDone = false
        var min = "0"
        var max = "0"
        for c in type {
            switch c {
            case " ":
                continue
            case ",":
                minDone = true
            default:
                if minDone {
                    max += String(c)
                } else {
                    min += String(c)
                }
            }
        }
        
        let comp = type.range(of: ".") != nil ? 0.5 : 1
        let intMin = Double(min) ?? 0
        let intMax = (Double(max) ?? 0) + 1
        
        self.setPickerView(stride(from: intMin, to: intMax, by: comp).map{
            String($0)
        })
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Votre progression sera perdu", message: "Êtes-vous sûr de vouloir quitter ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Oui", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
extension MPQuestionFormViewController {
    
    func setQuestion(number : Int) {
        guard let curr = self.questions?[question] else {
            // TODO : handle error
            return
        }
        
        self.numberQuestionLabel.text = "\(question + 1)"
        UIView.animate(withDuration: 0.7) {
            self.progressViewWidthConstraint.constant = self.questionView.frame.width - self.questionView.frame.width * (CGFloat(self.question + 1) / CGFloat(self.amount ?? 1))
            self.view.layoutIfNeeded()
        }
        
        self.questionLabel.text = curr.question ?? "N/A"
        self.profile_questions_id = curr.id
        self.answers = curr.answers ?? []
        let type = curr.answer_type ?? ""
        
        switch type {
        case "date" :
            self.setDatePicker()
        case "number":
            self.setPickerView(stride(from: 40, to: 240, by: 1).map{
                String($0)
            })
        case "decimal":
            self.setPickerView(stride(from: 0.0, to: 5.0, by: 0.5).map{
                String($0)
            })
        case "select":
            self.setTableView()
        case "country":
            self.setPickerView(NSLocale.isoCountryCodes.map{
                return NSLocale(localeIdentifier: "en").localizedString(forCountryCode: $0) ?? $0
            }.sorted())
        case "boolean":
            self.setPickerView(["true", "false"])
        default:
            if type.range(of: "range", options: .regularExpression, range: nil, locale: nil) != nil {
                var tmp = type
                tmp = tmp.replacingOccurrences(of: "range(", with: "", options: NSString.CompareOptions.literal, range: nil)
                tmp = tmp.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.parseAnswerType(tmp)
            }
        }
    }
    
    func setDatePicker() {
        let datepicker = UIDatePicker(frame: CGRect(x: 0,
                                                y: 0,
                                                width: self.responseView.frame.width,
                                                height: self.responseView.frame.height))
        datepicker.timeZone = NSTimeZone.local
        datepicker.backgroundColor = UIColor.white
        datepicker.datePickerMode = .date
        datepicker.maximumDate = Date()
        if let defaultDate = MPProfileDataStore().getBirthDate() {
            datepicker.setDate(defaultDate, animated: false)
        }
        datepicker.addTarget(self, action: #selector(self.targetDatePickerAction(_:)), for: UIControl.Event.valueChanged)
        self.responseView.addSubview(datepicker)
    }
    
    @objc func targetDatePickerAction(_ sender: UIDatePicker) {
        let dateFormatter = ISO8601DateFormatter()
        self.curResultAnswer = Answers(profile_questions_id: self.profile_questions_id ?? -1, answer: dateFormatter.string(from: sender.date))
    }

}

extension MPQuestionFormViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func setPickerView(_ data : [String]) {
        self.dataPicker = data
        
        let answer = UIPickerView(frame: CGRect(x: 0, y: 0,
                                                width: self.responseView.frame.width,
                                                height: self.responseView.frame.height))
        answer.delegate = self
        answer.dataSource = self
        self.responseView.addSubview(answer)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataPicker?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataPicker?[row] ?? "N/A"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.curResultAnswer = Answers(profile_questions_id: self.profile_questions_id ?? -1, answer: self.dataPicker?[row] ?? "")
    }
}

extension MPQuestionFormViewController : UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        let answer = UITableView(frame: CGRect(x: 0, y: 0,
                                               width: self.responseView.frame.width,
                                               height: self.responseView.frame.height))
        answer.register(UINib(nibName: "FormCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        answer.delegate = self
        answer.dataSource = self
        answer.allowsSelection = true
        self.responseView.addSubview(answer)
        
        // TODO : default selection
//        let indexPath = IndexPath(row: 0, section: 0)
//        answer.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as? MPAnswerTableViewCell else {
            return UITableViewCell()
        }
        cell.answerLabel.text = self.answers?[indexPath.row] ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let nb = self.answers?.count else {
            return 60
        }
        return self.responseView.frame.height / CGFloat(nb)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MPAnswerTableViewCell
        let gray = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        cell?.backgroundColor = gray
        self.curResultAnswer = Answers (profile_questions_id: self.profile_questions_id ?? -1, answer: self.answers?[indexPath.row] ?? "")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MPAnswerTableViewCell
        cell?.backgroundColor = .clear
    }
}
