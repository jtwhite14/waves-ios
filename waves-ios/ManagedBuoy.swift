//
//  ManagedBuoy.swift
//  waves-ios
//
//  Created by Charlie White on 1/13/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import CoreData

class ManagedBuoy: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var title: String
    @NSManaged var buoyDescription: String
    @NSManaged var stationId: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var currentObservation: waves_ios.ManagedObservation
    
    
    func mapTitle() -> (NSString) {
        if (buoyDescription != "") {
            return buoyDescription
        } else {
            return title
        }
        
    }
}
