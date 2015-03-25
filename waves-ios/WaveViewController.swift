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
    func presentBuoy(observation:ManagedObservation, isCurrentObservation:Bool)
    func displayDeleteSessionSheet(session:ManagedSession)
}

class WaveViewController: UIViewController, UITableViewDataSource, SessionDelegate {
    
    var wave: ManagedWave!
    var sessions: [Session]! = []
    var allowMapDisplay:Bool! = true
    
    // Performance fix for new sessions
    var newSessionIdentifier:NSString!
    var newSessionImage:UIImage!
    
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
    @IBOutlet var presentBuoyButton: UIButton!
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

        
        self.waveDistanceLabel.text = "\(self.wave.distance) miles away"
        self.waveNameLabel.text = self.wave.slug
        if ((self.wave.buoy) != nil) {
            self.buoyStationLabel.text = "Buoy \(self.wave.buoy.stationId)"
        
            if ((self.wave.buoy.currentObservation) != nil) {
                self.presentBuoyButton.enabled = true
                self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(self.wave.buoy.currentObservation.waveHeight)!) ft"
                self.swellPeriodLabel.text = "\(self.formatter.stringFromNumber(self.wave.buoy.currentObservation.swellPeriod)!) sec"
                self.waveDirectionLabel.text = "(\(self.wave.buoy.currentObservation.meanWaveDirection.stringValue)°)"
                
                if (self.wave.buoy.currentObservation.windDirection != nil) {
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "wind-icon-halfsize-white")
                    let attachmentString = NSAttributedString(attachment: attachment)
                    let myString = NSMutableAttributedString(string: self.wave.buoy.currentObservation.windDirection)
                    myString.insertAttributedString(attachmentString, atIndex: 0)
                    self.swellDirectionLabel.attributedText = myString

                }
            } else {
                self.presentBuoyButton.enabled = false
            }
        } else {
            self.presentBuoyButton.enabled = false
        }
        
        self.loadWave()
    }
    
    func loadWave() {
        let params : NSDictionary = [ "latitude" : LocationClient.sharedClient().currentLocation.latitude , "longitude" : LocationClient.sharedClient().currentLocation.longitude ]
        
        Wave.getWave(self.wave.identifier, withParams:params, withCompletion: { (wave:Wave!) in
            self.fetchedResultsController.performFetch(nil)
            self.tableView.reloadData()
        })
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let fetchRequest = NSFetchRequest(entityName: "Session")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
 
        let predicate = NSPredicate(format: "wave.identifier == %@", self.wave.identifier)
        fetchRequest.predicate = predicate
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.performFetch(nil)
        
        return controller
        }()
    
    func numberOfSessions() -> (Int) {
        var count : Int!
        if let s = self.fetchedResultsController.sections as? [NSFetchedResultsSectionInfo] {
            count = s[0].numberOfObjects
        }
        return count
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
        return self.numberOfSessions()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCellIdentifier", forIndexPath: indexPath) as SessionCell
        //let session : Session = self.sessions[indexPath.row] as Session
        let session = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedSession
        
        //performance hack, if this is a newly created session, display the local image first, to give time for uploading.
        if (newSessionIdentifier != nil && newSessionIdentifier == session.identifier) {
            cell.configureSession(session, image: newSessionImage)
        } else {
            cell.configureSession(session)
        }
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCellIdentifier") as SessionCell
        //let session : Session = self.sessions[indexPath.row] as Session
        let session = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedSession
        
        cell.configureSession(session)
        cell.layoutIfNeeded()
        let size:CGSize = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    @IBAction func showCurrentBuoyObservation(sender: AnyObject) {
        presentBuoy(self.wave.buoy.currentObservation, isCurrentObservation:true)
    }
    
    func presentBuoy(observation:ManagedObservation, isCurrentObservation:Bool) {
        let observationVC = ObservationViewController(nibName: "ObservationViewController", bundle: nil)
        observationVC.managedBuoy = self.wave.buoy
        observationVC.managedObservation = observation
        observationVC.allowMapDisplay = true
        observationVC.isCurrentObservation = isCurrentObservation
        self.navigationController?.pushViewController(observationVC, animated: true)
    }
    
    @IBAction func showMapView(sender: AnyObject) {
        if (allowMapDisplay == true) {
            let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
            mapVC.startingRegion =  CLLocationCoordinate2D(latitude: CLLocationDegrees(self.wave.latitude),longitude:  CLLocationDegrees(self.wave.longitude))
            let MapNav = UINavigationController(rootViewController: mapVC)
            self.presentViewController(MapNav, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func displayDeleteSessionSheet(session:ManagedSession) {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Delete Session", style: .Destructive, handler: { action in
            switch action.style{
            case .Default:
                println("default")
            case .Cancel:
                println("cancel")
            case .Destructive:
                println("cancel")
                Session.destroySession(session.identifier, withCompletion: { (destroyed:Bool) in
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    appDelegate.managedObjectContext.deleteObject(session)
                    appDelegate.managedObjectContext.save(nil)
                    self.fetchedResultsController.performFetch(nil)
                    self.tableView.reloadData()
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
