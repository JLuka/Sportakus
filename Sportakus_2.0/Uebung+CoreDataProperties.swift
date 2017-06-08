//
//  Uebung+CoreDataProperties.swift
//  Sportakus_2.0
//
//  Created by Florian Meinert on 08.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import Foundation
import CoreData


extension Uebung {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Uebung> {
        return NSFetchRequest<Uebung>(entityName: "Uebung")
    }

    @NSManaged public var name: String?
    @NSManaged public var gewicht: Double
    @NSManaged public var wiederholungen: Int32
    @NSManaged public var saetze: Int32
    @NSManaged public var toPlan: Plan?

}
