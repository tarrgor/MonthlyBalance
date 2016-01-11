//
//  Account+CoreDataProperties.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 10.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Account {

    @NSManaged var balanceCurrentMonth: NSNumber?
    @NSManaged var balanceCurrentYear: NSNumber?
    @NSManaged var balanceTotal: NSNumber?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var name: String?
    @NSManaged var password: NSData?
    @NSManaged var activities: NSOrderedSet?
    @NSManaged var scheduledEvents: NSOrderedSet?

}
