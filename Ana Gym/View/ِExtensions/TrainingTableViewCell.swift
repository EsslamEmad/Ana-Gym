//
//  TrainingTableViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 1/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import WebKit

class TrainingTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var playSign: UIImageView!
    @IBOutlet weak var bigView: UIView!
    var webView: WKWebView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = ""
        playSign.alpha = 0
        if webView != nil{
            webView?.alpha = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
