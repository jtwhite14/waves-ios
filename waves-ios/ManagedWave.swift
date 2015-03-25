//
//  waves_ios.swift
//  waves-ios
//
//  Created by Charlie White on 1/23/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import CoreData

class ManagedWave: NSManagedObject {

    @NSManaged var identifier: NSString!
    @NSManaged var slug: NSString!
    @NSManaged var titlePhotoUrl: NSString!
    @NSManaged var mapPhotoUrl: NSString!
    @NSManaged var distance: NSNumber!
    @NSManaged var latitude: NSNumber!
    @NSManaged var longitude: NSNumber!
    @NSManaged var sessionsCount: NSNumber!
    @NSManaged var buoy: waves_ios.ManagedBuoy!
    @NSManaged var sessions: NSSet!
    
}
