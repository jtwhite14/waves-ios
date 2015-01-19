//
//  SessionCell.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import DateTools
import HanekeSwift

class SessionCell: UITableViewCell {
    
    var session:Session!
    var delegate:SessionDelegate?
    
    @IBOutlet var swellPeriodLabel: UILabel!
    @IBOutlet var waveHeightLabel: UILabel!
    @IBOutlet var waveDirectionLabel: UILabel!
    @IBOutlet var swellDirectionLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var starRatingView: StarView!
    @IBOutlet var sessionPhotoView: UIImageView!

    let formatter = NSNumberFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset = UIEdgeInsetsMake(0.0, self.frame.size.width, 0.0, 0.0)
        self.formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        self.formatter.maximumFractionDigits = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureSession(session: Session) {
        self.session = session
        
        self.descriptionLabel.text = session.notes
        self.timeAgoLabel.text =  session.timestamp.timeAgoSinceNow()
        self.starRatingView.setStarRating(session.rating.intValue)
        self.sessionPhotoView.hnk_setImageFromURL(NSURL(string:session.photoUrl)!, placeholder:UIImage(named: "placeholder-img"))

        if ((session.observation) != nil) {
            self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(session.observation!.waveHeight)!) ft"
            self.swellPeriodLabel.text = "\(self.formatter.stringFromNumber(session.observation!.swellPeriod)!) sec"
            self.waveDirectionLabel.text = "(\(session.observation!.meanWaveDirection.stringValue))"
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "wind-icon-halfsize-blue")
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: session.observation!.swellDirection)
            myString.insertAttributedString(attachmentString, atIndex: 0)
            self.swellDirectionLabel.attributedText = myString
        }
    }
    
    @IBAction func showSessionObservation(sender: AnyObject) {
        self.delegate?.presentBuoy(self.session.observation, isCurrentObservation:false)
    }
    
    @IBAction func showDeleteSessionSheet(sender: AnyObject) {
        self.delegate?.displayDeleteSessionSheet(self.session)
    }
    
}
