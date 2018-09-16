//
//  NutritionTableViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 29/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
