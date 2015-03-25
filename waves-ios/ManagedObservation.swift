//
//  waves_ios.swift
//  waves-ios
//
//  Created by Charlie White on 1/20/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import Foundation
import CoreData

class ManagedObservation: NSManagedObject {

    @NSManaged var averageWavePeriod: NSNumber!
    @NSManaged var identifier: String!
    @NSManaged var meanWaveDirection: NSNumber!
    @NSManaged var steepness: String!
    @NSManaged var swellDirection: String!
    @NSManaged var swellHeight: NSNumber!
    @NSManaged var swellPeriod: NSNumber!
    @NSManaged var timestamp: NSDate!
    @NSManaged var waveHeight: NSNumber!
    @NSManaged var windWaveHeight: NSNumber!
    @NSManaged var windWavePeriod: NSNumber!
    @NSManaged var windSpeed: NSNumber!
    @NSManaged var windGusts: NSNumber!
    @NSManaged var windDirection: String!
    @NSManaged var meanWindDirection: NSNumber!
    @NSManaged var airTemp: NSNumber!
    @NSManaged var waterTemp: NSNumber!
    @NSManaged var logTideTimestamp: NSDate!
    @NSManaged var logTideValue: NSNumber!
    @NSManaged var firstLowValue: NSNumber!
    @NSManaged var firstLowTimestamp: NSDate!
    @NSManaged var secondLowValue: NSNumber!
    @NSManaged var secondLowTimestamp: NSDate!
    @NSManaged var firstHighValue: NSNumber!
    @NSManaged var firstHighTimestamp: NSDate!
    @NSManaged var secondHighValue: NSNumber!
    @NSManaged var secondHighTimestamp: NSDate!
    @NSManaged var buoy: waves_ios.ManagedBuoy

}
