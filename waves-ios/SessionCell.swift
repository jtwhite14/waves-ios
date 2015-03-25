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
    
    var session:ManagedSession!
    var delegate:SessionDelegate?
    
    @IBOutlet var swellPeriodLabel: UILabel!
    @IBOutlet var waveHeightLabel: UILabel!
    @IBOutlet var waveDirectionLabel: UILabel!
    @IBOutlet var swellDirectionLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var starRatingView: StarView!
    @IBOutlet var sessionPhotoView: UIImageView!
    @IBOutlet var showObservationData: UIButton!

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
    
    
    func configureSession(session: ManagedSession) {
        self.session = session
        
        self.descriptionLabel.text = session.notes
        self.timeAgoLabel.text =  session.timestamp.timeAgoSinceNow()
        self.starRatingView.setStarRating(session.rating.intValue)
        if((session.photoUrl) != nil) {
            self.sessionPhotoView.hnk_setImageFromURL(NSURL(string:session.photoUrl)!, placeholder:UIImage(named: "placeholder-img"))
        }
       

        if ((session.observation) != nil) {
            configureObservation(session.observation)
        } else {
            self.showObservationData.enabled = false
        }
    }
    
    func configureSession(session: ManagedSession, image:UIImage) {
        self.session = session
        
        self.descriptionLabel.text = session.notes
        self.timeAgoLabel.text =  session.timestamp.timeAgoSinceNow()
        self.starRatingView.setStarRating(session.rating.intValue)
        if((session.photoUrl) != "") {
            self.sessionPhotoView.hnk_setImageFromURL(NSURL(string:session.photoUrl)!, placeholder:UIImage(named: "placeholder-img"))
        } else {
            self.sessionPhotoView.image = image
        }
        

        if ((session.observation) != nil) {
            configureObservation(session.observation)
        } else {
            configureEmptyObservation()
        }
    }
    
    func configureObservation(o:ManagedObservation) {
        self.showObservationData.enabled = true
        self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(o.waveHeight)!) ft"
        self.swellPeriodLabel.text = "\(self.formatter.stringFromNumber(o.swellPeriod)!) sec"
        self.waveDirectionLabel.text = "(\(o.meanWaveDirection.stringValue)°)"
        
        if (o.windDirection != nil) {
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "wind-icon-halfsize-blue")
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: o.windDirection)
            myString.insertAttributedString(attachmentString, atIndex: 0)
            self.swellDirectionLabel.attributedText = myString
        }
    }
    
    func configureEmptyObservation() {
        self.showObservationData.enabled = false
        self.waveHeightLabel.text = "-- ft"
        self.swellPeriodLabel.text = "-- sec"
        self.waveDirectionLabel.text = "(--°)"
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "wind-icon-halfsize-blue")
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "--")
        myString.insertAttributedString(attachmentString, atIndex: 0)
        self.swellDirectionLabel.attributedText = myString

    }
    
    @IBAction func showSessionObservation(sender: AnyObject) {
        self.delegate?.presentBuoy(self.session.observation, isCurrentObservation:false)
    }
    
    @IBAction func showDeleteSessionSheet(sender: AnyObject) {
        self.delegate?.displayDeleteSessionSheet(self.session)
    }
    
}
