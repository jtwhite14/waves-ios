//
//  WaveNameCell.swift
//  waves-ios
//
//  Created by Charlie White on 1/9/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class WaveNameCell: UITableViewCell {
    
    @IBOutlet var waveNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
