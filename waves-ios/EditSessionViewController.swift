//
//  EditSessionViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/9/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import RMDateSelectionViewController

@objc protocol SetWaveDelegate{
     func setWave(wave: Wave)
}

class EditSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RMDateSelectionViewControllerDelegate, SetWaveDelegate, StarViewProtocol {
    
    var createdSessionIdentifier:NSString!
    var session : Session!
    var sessionPhoto : UIImage!
    var waves: [Wave]! = []
    var selectedWave : Wave!
    let timeFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()
    var delegate:PresentWaveDelegate?


    @IBOutlet var notesTextField: UITextView!
    @IBOutlet var sessionDateButton: UIButton!
    @IBOutlet var sessionTimeButton: UIButton!
    @IBOutlet var sessionPhotoView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var starView: LargeStarView!
    @IBOutlet var createSessionButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveSessionNotification:", name: "session-photo-uploaded", object: nil)
        
        self.createSessionButton.setImage(UIImage(named: "inactive-btn"), forState: UIControlState.Disabled)
        self.createSessionButton.enabled = false
        
        self.starView.delegate = self
        
        
        let nibName = UINib(nibName: "WaveNameCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "WaveNameCellIdentifier")
        let newWavenibName = UINib(nibName: "NewWaveCell", bundle:nil)
        self.tableView.registerNib(newWavenibName, forCellReuseIdentifier: "NewWaveCellIdentifier")
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.tableHeaderView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        
        
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
            
        self.sessionPhotoView.image = sessionPhoto
        self.sessionTimeButton.setTitle(timeFormatter.stringFromDate(self.session.timestamp), forState: .Normal)
        self.sessionDateButton.setTitle(dateFormatter.stringFromDate(self.session.timestamp), forState: .Normal)
        
        loadWaves()
    }
    
    func receiveSessionNotification(notification:NSNotification) {
        let tmp : [NSObject : AnyObject] = notification.userInfo!
        let sessionIdentifer = tmp["identifer"] as NSString
        self.createdSessionIdentifier = sessionIdentifer
        self.validateSession()
    }
    
    func loadWaves() {
        
        var params: NSDictionary
        if ((self.session.latitude) != nil) {
            params = [ "latitude" : self.session.latitude , "longitude" : self.session.longitude, "limit" : 2 ]
        } else {
            params = [ "latitude" : LocationClient.sharedClient().currentLocation.latitude , "longitude" : LocationClient.sharedClient().currentLocation.longitude, "limit" : 2 ]
        }
        

        Wave.getClosestWaves(params, withCompletion: {(waves:[AnyObject]!)  in
            self.waves = waves as? [Wave]
            self.tableView.reloadData()
        })
    }
    
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.waves.count + 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if (row == self.waves.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("WaveNameCellIdentifier", forIndexPath: indexPath) as WaveNameCell
            cell.waveNameLabel.text = "More Waves..."
            return cell
        } else if (row == (self.waves.count + 1)) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewWaveCellIdentifier", forIndexPath: indexPath) as NewWaveCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("WaveNameCellIdentifier", forIndexPath: indexPath) as WaveNameCell
          let wave : Wave = self.waves[row] as Wave
          cell.waveNameLabel.text = wave.slug
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        if (row == self.waves.count) {
           let allWavesVC = AllWavesTableViewController()
            allWavesVC.delegate = self
            let allWavesNav = UINavigationController(rootViewController: allWavesVC)
            self.presentViewController(allWavesNav, animated: true, completion: nil)
        } else if (row == (self.waves.count + 1)) {
            let newWaveVC = NewWaveViewController(nibName: "NewWaveViewController", bundle: nil)
            newWaveVC.region =  CLLocationCoordinate2D(latitude: CLLocationDegrees(self.session.latitude),longitude:  CLLocationDegrees(self.session.longitude))
            newWaveVC.delegate = self
            self.presentViewController(newWaveVC, animated: true, completion: nil)
            
        } else {
            self.selectedWave = self.waves[indexPath.row] as Wave
            let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryView = UIImageView(image: UIImage(named: "wave-check-icon"))
            cell.accessoryView!.frame = CGRectMake(cell.accessoryView!.frame.origin.x, 13, 21, 16)
            self.validateSession()
        }
        
    }
    
    func setWave(wave: Wave) {
        self.selectedWave = wave
        self.waves = [wave]
        self.tableView.reloadData()
        let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!
        cell.accessoryView = UIImageView(image: UIImage(named: "wave-check-icon"))
        cell.accessoryView!.frame = CGRectMake(cell.accessoryView!.frame.origin.x, 13, 21, 16)
        self.validateSession()
    }
    
    func ratingUpdated(currentRating: UInt) {
        self.validateSession()
    }
    
    @IBAction func createSession(sender: AnyObject) {
        self.createSessionButton.enabled = false
        
        let params : NSDictionary = [ "session" : [
            "latitude" : self.session.latitude,
            "longitude" : self.session.longitude,
            "notes" : self.notesTextField.text,
            "rating" : "\(self.starView.currentRating)",
            "wave_id" : self.selectedWave.identifier,
            "timestamp" : self.session.timestamp
            ]
        ]
        self.delegate?.presentWave(self.selectedWave, animated: false)
        Session.finalizeSession(params, withSessionID: self.createdSessionIdentifier, withCompletion: { (session:Session!) in
            self.dismissViewControllerAnimated(true, completion: {
                return
            })
        })
    }
    
    func validateSession() {
        if ((self.selectedWave != nil) && (self.starView.currentRating != 0) && (self.createdSessionIdentifier != nil)) {
            self.createSessionButton.enabled = true
        } else {
            self.createSessionButton.enabled = false
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryView! = UIView(frame: CGRectZero)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        notesTextField.endEditing(true)
    }
    
    @IBAction func displayDatePicker(sender: AnyObject) {
        let dateSelectionVC = RMDateSelectionViewController.dateSelectionController()
        dateSelectionVC.delegate = self
        dateSelectionVC.datePicker.datePickerMode = .Date
        dateSelectionVC.tintColor = UIColor(red: 0, green: 0.706, blue: 1, alpha: 1)
        dateSelectionVC.datePicker.tag = 0
        dateSelectionVC.datePicker.date = self.session.timestamp
        dateSelectionVC.show()
    }
    
    @IBAction func displayTimePicker(sender: AnyObject) {
        let dateSelectionVC = RMDateSelectionViewController.dateSelectionController()
        dateSelectionVC.delegate = self
        dateSelectionVC.datePicker.datePickerMode = .Time
        dateSelectionVC.tintColor = UIColor(red: 0, green: 0.706, blue: 1, alpha: 1)
        dateSelectionVC.datePicker.tag = 1
        dateSelectionVC.datePicker.date = self.session.timestamp
        dateSelectionVC.show()
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dateSelectionViewController(vc: RMDateSelectionViewController!, didSelectDate aDate: NSDate!) {
        NSLog(aDate.description)
        let dateComps = NSCalendarUnit.YearCalendarUnit |  NSCalendarUnit.MonthCalendarUnit |  NSCalendarUnit.DayCalendarUnit
        
        let timeComps = NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        
        
        if (vc.datePicker.tag == 0) {
            
            let calendar = NSCalendar.currentCalendar()
            let newComps : NSDateComponents = calendar.components(timeComps, fromDate: self.session.timestamp)
            let newDateComps : NSDateComponents = calendar.components(dateComps, fromDate: aDate)
            
            newComps.year = newDateComps.year
            newComps.month = newDateComps.month
            newComps.day = newDateComps.day
            self.session.timestamp = calendar.dateFromComponents(newComps)
            
            self.sessionDateButton.setTitle(dateFormatter.stringFromDate(self.session.timestamp), forState: .Normal)
            sessionDateButton.setNeedsLayout()
            sessionDateButton.layoutIfNeeded()
        } else {
            let calendar = NSCalendar.currentCalendar()
            let newComps : NSDateComponents = calendar.components(dateComps, fromDate: self.session.timestamp)
            let newTimeComps : NSDateComponents = calendar.components(timeComps, fromDate: aDate)
            
            newComps.hour = newTimeComps.hour
            newComps.minute = newTimeComps.minute
            newComps.second = newTimeComps.second
            
            self.session.timestamp = calendar.dateFromComponents(newComps)
            self.sessionTimeButton.setTitle(timeFormatter.stringFromDate(self.session.timestamp), forState: .Normal)
            sessionTimeButton.setNeedsLayout()
            sessionTimeButton.layoutIfNeeded()
        }
    }
}
