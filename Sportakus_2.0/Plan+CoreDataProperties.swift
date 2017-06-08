//
//  Plan+CoreDataProperties.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var name: String?
    @NSManaged public var toUebungen: NSSet?

}

// MARK: Generated accessors for toUebungen
extension Plan {

    @objc(addToUebungenObject:)
    @NSManaged public func addToToUebungen(_ value: Uebung)

    @objc(removeToUebungenObject:)
    @NSManaged public func removeFromToUebungen(_ value: Uebung)

    @objc(addToUebungen:)
    @NSManaged public func addToToUebungen(_ values: NSSet)

    @objc(removeToUebungen:)
    @NSManaged public func removeFromToUebungen(_ values: NSSet)

}
