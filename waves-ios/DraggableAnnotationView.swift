//
//  DraggableAnnotationView.swift
//  waves-ios
//
//  Created by Charlie White on 1/14/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import MapKit



class DraggableAnnotationView: MKAnnotationView {
 
    var fingerPoint : CGPoint!
    var mapView : MKMapView!
    
    override func setDragState(newDragState: MKAnnotationViewDragState, animated: Bool) {
        if ((self.mapView) != nil) {
           let mapDelegate = mapView.delegate
            mapDelegate.mapView!(self.mapView, annotationView: self, didChangeDragState: newDragState, fromOldState: self.dragState)
        }
        
        let liftValue = -(self.fingerPoint.y - self.frame.size.height - 20.0)
        
        if (newDragState == MKAnnotationViewDragState.Starting) {
            let endPoint = CGPointMake(self.center.x, self.center.y-liftValue)
            UIView.animateWithDuration(0.2, animations: { () in
                self.center = endPoint
                }, completion: { (finished:Bool) in
                    self.dragState = MKAnnotationViewDragState.Dragging
            })
            
        } else if (newDragState == MKAnnotationViewDragState.Ending) {
            let endPoint = CGPointMake(self.center.x, self.center.y+liftValue)
                    UIView.animateWithDuration(0.1, animations: { () in
                        self.center = endPoint
                        }, completion: { (finished:Bool) in
                            self.dragState = MKAnnotationViewDragState.None
                        })
                           
                   
        } else if (newDragState == MKAnnotationViewDragState.Canceling) {
            let endPoint = CGPointMake(self.center.x, self.center.y+liftValue)
            UIView.animateWithDuration(0.1, animations: { () in
                self.center = endPoint
                }, completion: { (finished:Bool) in
                    self.dragState = MKAnnotationViewDragState.None
            })
        }
    }
    
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        self.fingerPoint = point
        return(super.hitTest(point, withEvent: event))
    }
    
    
}
