//
//  ProgramTableViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 19/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var programImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 60, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.view.bounds.width, y: self.view.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        view.layer.mask = shapeLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
