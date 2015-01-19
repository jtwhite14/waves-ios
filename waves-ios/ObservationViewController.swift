//
//  ObservationViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/14/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class ObservationViewController: UIViewController {
    
    var buoy:Buoy!
    var managedBuoy:ManagedBuoy!
    
    var observation:Observation!
    var managedObservation:ManagedObservation!
    var allowMapDisplay:Bool! = false
    var isCurrentObservation:Bool! = false
    let dateFormatter = NSDateFormatter()

    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var buoyDescriptionLabel: UILabel!
    @IBOutlet var buoyNameLabel: UILabel!
    @IBOutlet var buoyAvatarView: BuoyAvatarView!
    var coordinate : CLLocationCoordinate2D!
    
    @IBOutlet var waveHeightLabel: UILabel!
    @IBOutlet var swellHeightLabel: UILabel!
    @IBOutlet var dominantPeriodLabel: UILabel!
    @IBOutlet var averagePeriodLabel: UILabel!
    @IBOutlet var meanDirectionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windGustsLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var airTempLabel: UILabel!
    @IBOutlet var waterTempLabel: UILabel!
    @IBOutlet var tideLogLabel: UILabel!
    @IBOutlet var tideFirstLowLabel: UILabel!
    @IBOutlet var tideSecondLowLabel: UILabel!
    @IBOutlet var tideFirstHighLabel: UILabel!
    @IBOutlet var tideSecondHighLabel: UILabel!
    @IBOutlet var tideLogTimeLabel: UILabel!
    @IBOutlet var tideFirstLowTimeLabel: UILabel!
    @IBOutlet var tideSecondLowTimeLabel: UILabel!
    @IBOutlet var tideFirstHighTimeLabel: UILabel!
    @IBOutlet var tideSecondHighTimeLabel: UILabel!
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        self.formatter.maximumFractionDigits = 1
        self.dateFormatter.dateStyle = .ShortStyle
        self.dateFormatter.timeStyle = .ShortStyle
        
        if (buoy != nil) {
            configureBuoy(buoy)
        } else if (managedBuoy != nil) {
            configureManagedBuoy(managedBuoy)
        }
        
        if (observation != nil) {
            configureObservation(observation)
        } else if (managedObservation != nil) {
            configureManagedObservation(managedObservation)
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func configureBuoy(buoy:Buoy) {
        self.buoyNameLabel.text = buoy.buoyDescription
        self.buoyDescriptionLabel.text = "Buoy \(buoy.stationId)"
        
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(buoy.latitude),longitude:  CLLocationDegrees(buoy.longitude))
        
        self.buoyAvatarView.setStartingRegion(self.coordinate)
    }
    
    func configureManagedBuoy(managedBuoy:ManagedBuoy) {
        self.buoyNameLabel.text = managedBuoy.buoyDescription
        self.buoyDescriptionLabel.text =  "Buoy \(managedBuoy.stationId)"
        
       self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(managedBuoy.latitude),longitude:  CLLocationDegrees(managedBuoy.longitude))
        
        self.buoyAvatarView.setStartingRegion(self.coordinate)
    }
    
    func configureTimestamp(timestamp:NSDate) {
        NSLog(self.dateFormatter.stringFromDate(timestamp))

        if(isCurrentObservation == true) {
            self.timestampLabel.text =  "Current Observation"
        } else {
            NSLog(self.dateFormatter.stringFromDate(timestamp))
            self.timestampLabel.text = self.dateFormatter.stringFromDate(timestamp)
        }
    }
    
    func configureObservation(o:Observation) {
        configureTimestamp(o.timestamp)
        
        
        self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(o.waveHeight)!) ft"
        self.swellHeightLabel.text = "\(self.formatter.stringFromNumber(o.swellHeight)!) ft"
        self.dominantPeriodLabel.text = "\(self.formatter.stringFromNumber(o.swellPeriod)!) sec"
        self.averagePeriodLabel.text = "\(self.formatter.stringFromNumber(o.averageWavePeriod)!) sec"
        self.meanDirectionLabel.text = "\(o.swellDirection) (\(o.meanWaveDirection.stringValue))"
        
    }
    
    func configureManagedObservation(o:ManagedObservation) {
        configureTimestamp(o.timestamp)
        
        self.waveHeightLabel.text = "\(self.formatter.stringFromNumber(o.waveHeight)!) ft"
        self.swellHeightLabel.text = "\(self.formatter.stringFromNumber(o.swellHeight)!) ft"
        self.dominantPeriodLabel.text = "\(self.formatter.stringFromNumber(o.swellPeriod)!) sec"
        self.averagePeriodLabel.text = "\(self.formatter.stringFromNumber(o.averageWavePeriod)!) sec"
        self.meanDirectionLabel.text = "\(o.swellDirection) (\(o.meanWaveDirection.stringValue))"
        
    }
    
    @IBAction func showMapView(sender: AnyObject) {
        if (allowMapDisplay == true) {
            let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
            mapVC.startingRegion =  self.coordinate
            let MapNav = UINavigationController(rootViewController: mapVC)
            self.presentViewController(MapNav, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
