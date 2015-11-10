//
//  Activity+CoreDataProperties.swift
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

extension Activity {

    @NSManaged var date: NSDate?
    @NSManaged var amount: NSNumber?
    @NSManaged var icon: String?
    @NSManaged var title: String?
    @NSManaged var account: Account?

}
