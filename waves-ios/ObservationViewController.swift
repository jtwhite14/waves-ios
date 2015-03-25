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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.timestampLabel.text = WavesFormatter.sharedClient().dateFormatter().stringFromDate(timestamp)
    }
    
    func configureObservation(o:Observation) {
        configureTimestamp(o.timestamp)
        
        

        
        self.waveHeightLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.waveHeight)!) ft"
        self.swellHeightLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.swellHeight)!) ft"
        self.dominantPeriodLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.swellPeriod)!) sec"
        self.averagePeriodLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.averageWavePeriod)!) sec"
        self.meanDirectionLabel.text = "(\(o.meanWaveDirection.stringValue)°)"
        
        if ((o.windSpeed) != nil) {
            self.windSpeedLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.windSpeed)!) knts"
        }
        if ((o.windGusts) != nil) {
            self.windGustsLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.windGusts)!) knts"
        }
        if ((o.windDirection) != nil) {
            self.windDirectionLabel.text = "\(o.windDirection) (\(o.meanWindDirection)°)"
        }
        if ((o.airTemp) != nil) {
            self.airTempLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.airTemp)!) °F"
        }
        if ((o.waterTemp) != nil) {
            self.waterTempLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.waterTemp)!) °F"
        }
        if ((o.logTideValue) != nil) {
            self.tideLogTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.logTideTimestamp)
            self.tideLogLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.logTideValue)!) ft"
        }
        if ((o.firstLowValue) != nil) {
            self.tideFirstLowLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.firstLowValue)!) ft"
            self.tideFirstLowTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.firstLowTimestamp)
        }
        if ((o.secondLowValue) != nil) {
           self.tideSecondLowLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.secondLowValue)!) ft"
             self.tideSecondLowTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.secondLowTimestamp)
        }
        if ((o.firstHighValue) != nil) {
            self.tideFirstHighLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.firstHighValue)!) ft"
            self.tideFirstHighTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.firstHighTimestamp)
        }
        if ((o.secondHighValue) != nil) {
            self.tideSecondHighLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.secondHighValue)!) ft"
            self.tideSecondHighTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.secondHighTimestamp)
        }
        
    }
    
    func configureManagedObservation(o:ManagedObservation) {
        configureTimestamp(o.timestamp)

        
        self.waveHeightLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.waveHeight)!) ft"
        self.swellHeightLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.swellHeight)!) ft"
        self.dominantPeriodLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.swellPeriod)!) sec"
        self.averagePeriodLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.averageWavePeriod)!) sec"
        self.meanDirectionLabel.text = "(\(o.meanWaveDirection.stringValue)°)"
        
        if ((o.windSpeed) != nil) {
            self.windSpeedLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.windSpeed)!) knts"
        }
        if ((o.windGusts) != nil) {
            self.windGustsLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.windGusts)!) knts"
        }
        if ((o.windDirection) != nil) {
            self.windDirectionLabel.text = "\(o.windDirection) (\(o.meanWindDirection)°)"
        }
        if ((o.airTemp) != nil) {
            self.airTempLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.airTemp)!) °F"
        }
        if ((o.waterTemp) != nil) {
            self.waterTempLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.waterTemp)!) °F"
        }
        if ((o.logTideValue) != nil) {
            self.tideLogTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.logTideTimestamp)
            self.tideLogLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.logTideValue)!) ft"
        }
        if ((o.firstLowValue) != nil) {
            self.tideFirstLowLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.firstLowValue)!) ft"
            self.tideFirstLowTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.firstLowTimestamp)
        }
        if ((o.secondLowValue) != nil) {
            self.tideSecondLowLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.secondLowValue)!) ft"
            self.tideSecondLowTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.secondLowTimestamp)
        }
        if ((o.firstHighValue) != nil) {
            self.tideFirstHighLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.firstHighValue)!) ft"
            self.tideFirstHighTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.firstHighTimestamp)
        }
        if ((o.secondHighValue) != nil) {
            self.tideSecondHighLabel.text = "\(WavesFormatter.sharedClient().numberFormatter().stringFromNumber(o.secondHighValue)!) ft"
            self.tideSecondHighTimeLabel.text = WavesFormatter.sharedClient().timeFormatter().stringFromDate(o.secondHighTimestamp)
        }
        
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
