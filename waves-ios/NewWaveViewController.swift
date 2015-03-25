//
//  NewWaveViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/14/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class NewWaveViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var waveNameLabel: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var createWaveButton: UIButton!
    var region : CLLocationCoordinate2D!
    var delegate:SetWaveDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWaveButton.setImage(UIImage(named:"inactive-check"), forState: UIControlState.Disabled)
        createWaveButton.enabled = false

        self.mapView.mapType = .Satellite
        self.mapView.showsUserLocation = false
        self.mapView.delegate = self
        
        self.setStartingRegion(self.region)

    }
    
    override func viewWillDisappear(animated: Bool) {
        waveNameLabel.endEditing(true)
    }
    
    func setStartingRegion(region:CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(region, 3000, 3000)
        self.mapView.setRegion(region, animated: false)
        
        var startingPin = MKPointAnnotation()
        startingPin.coordinate = self.region
        self.mapView.addAnnotation(startingPin)
    }

    func mapView(aMapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseId = "wave"
        //var startingView = aMapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        let startingView = DraggableAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        startingView.mapView = self.mapView
        startingView.canShowCallout = false
        startingView.image = UIImage(named: "spot-marker-icon")
        startingView.draggable = true
        //startingView.setDragState(MKAnnotationViewDragState.Starting, animated: true)
        
        return startingView
    }
    
    
   func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {

        if (newState == MKAnnotationViewDragState.Ending) {
            self.region = view.annotation.coordinate
        }
    }
   
    @IBAction func waveNameLabelChanged(sender: AnyObject) {
        if (self.waveNameLabel.text.utf16Count > 0) {
            self.createWaveButton.enabled = true
        } else {
            self.createWaveButton.enabled = false
        }
    }
    
    @IBAction func createWave(sender: AnyObject) {
        self.createWaveButton.enabled = false
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let params : NSDictionary = [ "wave" : [
            "latitude" : self.region.latitude,
            "longitude" : self.region.longitude,
            "slug" : self.waveNameLabel.text
            ]
        ]
        
        Wave.createWave(params, withCompletion: { (wave:Wave!) in
            hud.hide(true)
            self.delegate?.setWave(wave)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    @IBAction func didCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        waveNameLabel.endEditing(true)
    }

}
