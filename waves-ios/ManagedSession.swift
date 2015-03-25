//
//  waves_ios.swift
//  waves-ios
//
//  Created by Charlie White on 1/23/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import CoreData

class ManagedSession: NSManagedObject {

    @NSManaged var identifier: String!
    @NSManaged var notes: String!
    @NSManaged var rating: NSNumber!
    @NSManaged var photoUrl: String!
    @NSManaged var timestamp: NSDate!
    @NSManaged var latitude: NSNumber!
    @NSManaged var longitude: NSNumber!
    @NSManaged var observation: waves_ios.ManagedObservation!
    @NSManaged var wave: waves_ios.ManagedWave!

}
