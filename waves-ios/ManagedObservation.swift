//
//  ManagedObservation.swift
//  waves-ios
//
//  Created by Charlie White on 1/15/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import CoreData

class ManagedObservation: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var timestamp: NSDate
    @NSManaged var waveHeight: NSNumber
    @NSManaged var swellHeight: NSNumber
    @NSManaged var swellPeriod: NSNumber
    @NSManaged var windWaveHeight: NSNumber
    @NSManaged var windWavePeriod: NSNumber
    @NSManaged var swellDirection: String
    @NSManaged var steepness: String
    @NSManaged var averageWavePeriod: NSNumber
    @NSManaged var meanWaveDirection: NSNumber
    @NSManaged var buoy: waves_ios.ManagedBuoy

}
