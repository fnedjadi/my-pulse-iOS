//
//  ExercisesCell.swift
//  My Pulse
//
//  Created by Alexandre Toubiana on 14/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    var id: Int?

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var backgroundViewCell: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundViewCell?.layer.masksToBounds = false
        self.backgroundViewCell?.layer.shadowColor = UIColor.black.cgColor
        self.backgroundViewCell?.layer.shadowOpacity = 0.3
        self.backgroundViewCell?.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.backgroundViewCell?.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(exercise: Exercise) {
        self.id = exercise.id
        exerciseLabel.text = exercise.title
        exerciseImageView.image = exercise.image
    }

}
