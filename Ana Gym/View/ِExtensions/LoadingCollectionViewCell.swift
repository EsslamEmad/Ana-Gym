//
//  LoadingCollectionViewCell.swift
//  Ana Gym
//
//  Created by Esslam Emad on 19/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingLabel: UILabel!
    var i = 0
    var texts = [NSLocalizedString("جاري التحميل.", comment: ""), NSLocalizedString("جاري التحميل..", comment: ""), NSLocalizedString("جاري التحميل...", comment: "")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            guard self.i >= 0 , self.i <= 2 else {
                return
            }
            self.loadingLabel.text = self.texts[self.i]
            self.i += 1
            if self.i == 3 { self.i = 0}
        }
        RunLoop.current.add(timer, forMode: .commonModes)
        self.backgroundColor = .clear
    }
}
