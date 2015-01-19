//
//  SpacedLabel.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class SpacedLabel: UILabel {
    
    override func drawTextInRect(rect:CGRect) {
        let insets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        let insetsRect : CGRect = UIEdgeInsetsInsetRect(rect, insets)
        return super.drawTextInRect(insetsRect)
    }
   
}
