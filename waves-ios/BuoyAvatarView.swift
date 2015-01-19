//
//  BuoyAvatarView.swift
//  waves-ios
//
//  Created by Charlie White on 1/15/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import MapKit


class BuoyAvatarView : MKMapView, MKMapViewDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.mapType = MKMapType.Satellite
        self.userInteractionEnabled = false
        
        
    }
    
    func setStartingRegion(coordinates:CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 30000, 30000)
        self.setRegion(region, animated: false)
        
        var startingPin = MKPointAnnotation()
        startingPin.coordinate = coordinates
        self.addAnnotation(startingPin)
    }
    
    func mapView(aMapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseId = "buoy"
        let startingView = DraggableAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        startingView.mapView = self
        startingView.canShowCallout = false
        startingView.image = UIImage(named: "Buoy-map-icon")
        return startingView
    }
    
//    override func drawRect(rect: CGRect) {
//        self.attributionView().frame = CGRectMake(200, self.attributionView().frame.origin.y*2, self.attributionView().frame.size.width, self.attributionView().frame.size.height)
//        super.drawRect(rect)
//    }
    
}
