//
//  Address+CoreDataProperties.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var employee: Employee?

}
