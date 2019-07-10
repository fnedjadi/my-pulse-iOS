//
//  ExercisesViewController.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
    }
}

extension ExercisesViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ExercisesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConstantDatas.exerciseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        let index = ConstantDatas.exerciseData[indexPath.row]
        cell.configure(exercise: index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = ConstantDatas.exerciseData[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch index.id {
        case 0:
            let vc = storyboard.instantiateViewController(withIdentifier: "Workout")
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard.instantiateViewController(withIdentifier: "StandTest")
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard.instantiateViewController(withIdentifier: "Respiration")
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyboard.instantiateViewController(withIdentifier: "Relax")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            if let text = index.title {
                let alertController = UIAlertController(title: "Désolé", message: "L'activité \(text) n'est pas encore disponible!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
