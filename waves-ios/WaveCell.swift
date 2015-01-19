//
//  WaveCell.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import HanekeSwift

class WaveCell: UICollectionViewCell {

    @IBOutlet var waveNameLabel: UILabel!
    @IBOutlet var waveMilesLabel: UILabel!
    @IBOutlet var waveImageView: UIImageView!
    @IBOutlet var sessionCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        waveNameLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        waveMilesLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        sessionCountLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
        sessionCountLabel.layer.shadowRadius = 0
        sessionCountLabel.layer.shadowOpacity = 0.15
        sessionCountLabel.layer.shadowOffset = CGSizeMake(0.0, 0.5)
    }
    
    func configureWave(wave: Wave) {
        self.waveNameLabel?.text = "  \(wave.slug)  "
        self.sessionCountLabel.text = "\(wave.sessionsCount)"
        if ((wave.distance) != nil) {
            self.waveMilesLabel?.text = "  \(wave.distance) miles away  "
        } else {
            self.waveMilesLabel.hidden = true
        }
        self.waveImageView.hnk_setImageFromURL(NSURL(string:wave.titlePhotoUrl)!, placeholder:UIImage(named: "placeholder-img"))
    }

}
