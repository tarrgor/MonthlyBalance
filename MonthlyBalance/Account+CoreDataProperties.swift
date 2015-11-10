//
//  Account+CoreDataProperties.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
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
    @NSManaged var name: String?
    @NSManaged var password: NSData?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var activities: NSSet?
    @NSManaged var scheduledEvents: NSSet?

}
