//
//  LoopLabelView.swift
//  Ana Gym
//
//  Created by Esslam Emad on 19/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class LoopLabelView: UIView {
    
    private var labelText : String?
    private var rect0: CGRect!
    private var rect1: CGRect!
    private var labelArray = [UILabel]()
    private var isStop = false
    private var timeInterval: TimeInterval!
    private let leadingBuffer = CGFloat(25.0)
    private let loopStartDelay = 2.0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var text: String? {
        didSet {
            labelText = text
            setup()
        }
    }
    
    func setup() {
        self.backgroundColor = UIColor.yellow
        let label = UILabel()
        label.text = labelText
        label.frame = CGRect.zero
        
        timeInterval = TimeInterval((labelText?.characters.count)! / 5)
        let sizeOfText = label.sizeThatFits(CGSize.zero)
        let textIsTooLong = sizeOfText.width > frame.size.width ? true : false
        
        rect0 = CGRect(x: leadingBuffer, y: 0, width: sizeOfText.width, height: self.bounds.size.height)
        rect1 = CGRect(x: rect0.origin.x + rect0.size.width, y: 0, width: sizeOfText.width, height: self.bounds.size.height)
        label.frame = rect0
        
        super.clipsToBounds = true
        labelArray.append(label)
        self.addSubview(label)
        
        //self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 0, height: 0))
        
        if textIsTooLong {
            let additionalLabel = UILabel(frame: rect1)
            additionalLabel.text = labelText
            self.addSubview(additionalLabel)
            
            labelArray.append(additionalLabel)
            
            animateLabelText()
        }
    }
    
    func animateLabelText() {
        if(!isStop) {
            let labelAtIndex0 = labelArray[0]
            let labelAtIndex1 = labelArray[1]
            
            UIView.animate(withDuration: timeInterval, delay: loopStartDelay, options: [.curveLinear], animations: {
                labelAtIndex0.frame = CGRect(x: -self.rect0.size.width,y: 0,width: self.rect0.size.width,height: self.rect0.size.height)
                labelAtIndex1.frame = CGRect(x: labelAtIndex0.frame.origin.x + labelAtIndex0.frame.size.width,y: 0,width: labelAtIndex1.frame.size.width,height: labelAtIndex1.frame.size.height)
            }, completion: { finishied in
                labelAtIndex0.frame = self.rect1
                labelAtIndex1.frame = self.rect0
                
                self.labelArray[0] = labelAtIndex1
                self.labelArray[1] = labelAtIndex0
                self.animateLabelText()
            })
        } else {
            self.layer.removeAllAnimations()
        }
    }
}
