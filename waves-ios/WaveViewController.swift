//
//  WaveViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import IBActionSheet

@objc protocol SessionDelegate{
    func presentBuoy(observation:Observation, isCurrentObservation:Bool)
    func displayDeleteSessionSheet(session:Session)
}

class WaveViewController: UIViewController, UITableViewDataSource, SessionDelegate, IBActionSheetDelegate {
    
    var wave: Wave!
    var sessions: [Session]! = []
    @IBOutlet var tableView: UITableView!
    @IBOutlet var waveNameLabel: UILabel!
    @IBOutlet var waveDistanceLabel: UILabel!
    @IBOutlet var buoyStationLabel: UILabel!
    @IBOutlet var swellPeriodLabel: UILabel!
    @IBOutlet var waveHeightLabel: UILabel!
    @IBOutlet var waveDirectionLabel: UILabel!
    @IBOutlet var swellDirectionLabel: UILabel!
    @IBOutlet var metricsBackgroundView: UIView!
    @IBOutlet var waveAvatarView: WaveAvatarView!
    var prototypeCell : UITableViewCell!
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metricsBackgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
        self.metricsBackgroundView.layer.shadowRadius = 2
        self.metricsBackgroundView.layer.shadowOpacity = 0.35
        self.metricsBackgroundView.layer.shadowOffset = CGSizeMake(0.0, 0.5)
        self.metricsBackgroundView.layer.masksToBounds = false
        let shadowPath = UIBezierPath(rect: CGRectMake(0, 5, self.metricsBackgroundView.bounds.width, self.metricsBackgroundView.bounds.height-4.5))
        self.metricsBackgroundView.layer.shadowPath = shadowPath.CGPath
        
        self.formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        self.formatter.maximumFractionDigits = 1
        
        let nibName = UINib(nibName: "SessionCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "SessionCellIdentifier")
        
        self.waveAvatarView.setStartingRegion(CLLocationCoordinate2D(latitude: CLLocationDegrees(self.wave.latitude),longitude:  CLLocationDegrees(self.wave.longitude)))

        
        self.waveNameLabel.text = self.wave.slug
        self.buoyStationLabel.text = "Buoy \(self.wave.buoy.stationId)"
        self.waveDistanceLabel.text = "\(self.wave.distance) miles away"
        
        if ((self.wave.buoy.currentObservation) != nil) {
            self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(self.wave.buoy.currentObservation.waveHeight)!) ft"
            self.swellPeriodLabel.text = "\(self.formatter.stringFromNumber(self.wave.buoy.currentObservation.swellPeriod)!) sec"
            self.waveDirectionLabel.text = "(\(self.wave.buoy.currentObservation.meanWaveDirection.stringValue))"
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "wind-icon-halfsize-white")
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: self.wave.buoy.currentObservation.swellDirection)
            myString.insertAttributedString(attachmentString, atIndex: 0)
            self.swellDirectionLabel.attributedText = myString
        }
        
        
        self.loadSessions()
    }
    
    func loadSessions() {
        Session.getSessionsForWave(self.wave, {(sessions:[AnyObject]!)  in
            self.sessions = sessions as? [Session]
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
    }

    @IBAction func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.sessions.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCellIdentifier", forIndexPath: indexPath) as SessionCell
        let session : Session = self.sessions[indexPath.row] as Session
        cell.delegate = self
        cell.configureSession(session)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCellIdentifier") as SessionCell
        let session : Session = self.sessions[indexPath.row] as Session
        
        cell.configureSession(session)
        cell.layoutIfNeeded()
        let size:CGSize = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    @IBAction func showCurrentBuoyObservation(sender: AnyObject) {
        presentBuoy(self.wave.buoy.currentObservation, isCurrentObservation:true)
    }
    
    func presentBuoy(observation:Observation, isCurrentObservation:Bool) {
        let observationVC = ObservationViewController(nibName: "ObservationViewController", bundle: nil)
        observationVC.buoy = self.wave.buoy
        observationVC.observation = observation
        observationVC.allowMapDisplay = true
        observationVC.isCurrentObservation = isCurrentObservation
        self.navigationController?.pushViewController(observationVC, animated: true)
    }
    
    @IBAction func showMapView(sender: AnyObject) {
        let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
        mapVC.startingRegion =  CLLocationCoordinate2D(latitude: CLLocationDegrees(self.wave.latitude),longitude:  CLLocationDegrees(self.wave.longitude))
        let MapNav = UINavigationController(rootViewController: mapVC)
        self.presentViewController(MapNav, animated: true, completion: nil)
    }
    
    func displayDeleteSessionSheet(session:Session) {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Delete Session", style: .Destructive, handler: { action in
            switch action.style{
            case .Default:
                println("default")
            case .Cancel:
                println("cancel")
            case .Destructive:
                session.destroySessionWithCompletion({ (destroyed:Bool) in
                    self.loadSessions()
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
     func actionSheet(actionSheet: IBActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("clicked")
    }
    
}
