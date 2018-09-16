//
//  ProgramHomeCollectionViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class ProgramHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var programImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var coachLabel: UILabel!
    @IBOutlet var subscribtionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
