//
//  MapViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/12/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CCHMapClusterController

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, CCHMapClusterControllerDelegate {

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var regionSet = false
    var buoyClusterController : CCHMapClusterController!
    var startingRegion : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.mapType = .Satellite
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        if ((self.startingRegion) == nil) {
            self.setStartingRegion(LocationClient.sharedClient().currentLocation)
        } else {
            self.setStartingRegion(self.startingRegion)
        }
        
        self.buoyClusterController = CCHMapClusterController(mapView: self.mapView)
        self.buoyClusterController.delegate = self
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        loadWaves()
        loadBuoys()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setStartingRegion(region:CLLocationCoordinate2D) {
        if (!regionSet) {
            let region = MKCoordinateRegionMakeWithDistance(region, 160934, 160934)
            self.mapView.setRegion(region, animated: false)
            regionSet = true
        }
    }
    
    func loadWaves() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Wave", inManagedObjectContext: appDelegate.managedObjectContext)
        fetchRequest.entity = entity
        let annotationsArray = NSMutableArray()
        
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) -> Void in
            
            let waves = result.finalResult as [ManagedWave]
            for wave in waves {
                var wavePin = WavePointAnnotation()
                wavePin.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(wave.latitude),CLLocationDegrees(wave.longitude))
                wavePin.title = wave.slug
                wavePin.wave = wave
                self.mapView.addAnnotation(wavePin)
            }
        }
        
        appDelegate.managedObjectContext.performBlock { // 1
            var error : NSError?
            var results = appDelegate.managedObjectContext.executeRequest(asyncFetch,
                error: &error) as NSAsynchronousFetchResult
        }
    }
    
    func loadBuoys() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Buoy", inManagedObjectContext: appDelegate.managedObjectContext)
        fetchRequest.entity = entity
         let annotationsArray = NSMutableArray()
        
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) -> Void in
            
            let buoys = result.finalResult as [ManagedBuoy]
            for buoy in buoys {
                var buoyPin = BuoyPointAnnotation()
                buoyPin.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(buoy.latitude),CLLocationDegrees(buoy.longitude))
                buoyPin.title = buoy.mapTitle()
                buoyPin.buoy = buoy
                annotationsArray.addObject(buoyPin)
            }
            
           self.buoyClusterController.addAnnotations(annotationsArray, withCompletionHandler: nil)
        }
        
        appDelegate.managedObjectContext.performBlock { // 1
            var error : NSError?
            var results = appDelegate.managedObjectContext.executeRequest(asyncFetch,
                error: &error) as NSAsynchronousFetchResult
        }
    }
    
    func mapView(aMapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        } else if (annotation is WavePointAnnotation) {
            let reuseId = "wave"
            var waveView = aMapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if waveView == nil {
                waveView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                waveView.canShowCallout = true
            }
            else {
                //we are re-using a view, update its annotation reference...
                waveView.annotation = annotation
            }
            
            //waveView.image = UIImage(named:"wave-icon")
            waveView.layer.borderColor = UIColor.whiteColor().CGColor
            waveView.layer.borderWidth = 2

            let wpa = annotation as WavePointAnnotation
            let requestOperation = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: wpa.wave.mapPhotoUrl)!))
            requestOperation.responseSerializer = AFImageResponseSerializer()
            requestOperation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) in
                let image = responseObject as UIImage
                waveView.image = image
                }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                    NSLog(error.description)
                })
            requestOperation.start()
            

            let disclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            waveView.rightCalloutAccessoryView = disclosureButton
                
            return waveView
        } else {
            let reuseId = "buoy"
            var buoyView = aMapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if buoyView == nil {
                buoyView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                buoyView.image = UIImage(named:"buoymap-icon")
                buoyView.canShowCallout = true
            }
            else {
                //we are re-using a view, update its annotation reference...
                buoyView.annotation = annotation
            }
            
            let clusterAnnotation = annotation as CCHMapClusterAnnotation
            if (clusterAnnotation.isUniqueLocation()) {
                let disclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
                buoyView.rightCalloutAccessoryView = disclosureButton
            } else {
                buoyView.rightCalloutAccessoryView = nil
            }
            
            
            return buoyView
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if (view.reuseIdentifier == "wave") {
            let wpa = view.annotation as WavePointAnnotation
            let waveVC = WaveViewController(nibName: "WaveViewController", bundle: nil)
            waveVC.wave = wpa.wave
            waveVC.allowMapDisplay = false
            self.navigationController?.pushViewController(waveVC, animated: true)
        } else if(view.reuseIdentifier == "buoy") {
            let cchAnnotation = view.annotation as CCHMapClusterAnnotation
            let bpa = cchAnnotation.annotations.anyObject() as BuoyPointAnnotation
            let observationVC = ObservationViewController(nibName: "ObservationViewController", bundle: nil)
            observationVC.managedBuoy = bpa.buoy
            observationVC.managedObservation = bpa.buoy.currentObservation
            observationVC.isCurrentObservation = true
            self.navigationController?.pushViewController(observationVC, animated: true)
        }
    }
    

    func mapClusterController(mapClusterController:CCHMapClusterController, titleForMapClusterAnnotation mapClusterAnnotation:CCHMapClusterAnnotation) -> (NSString) {
        
        let numAnnotations = mapClusterAnnotation.annotations.count
        
        var unit : NSString
        if (numAnnotations > 1) {
            unit = "\(numAnnotations) buoys"
        } else {
            let annotation : MKPointAnnotation = mapClusterAnnotation.annotations.anyObject() as MKPointAnnotation
            unit = annotation.title
        }
        
        return unit
    }

   
    @IBAction func dismissView(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
