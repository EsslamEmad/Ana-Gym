//
//  WhoWeAreTableViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 22/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class WhoWeAreTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //let svgImgVar = getSvgImgFnc(svgImjFileNameVar: "about-bg", ClrVar : .white)
        //bgImage.image = svgImgVar
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
