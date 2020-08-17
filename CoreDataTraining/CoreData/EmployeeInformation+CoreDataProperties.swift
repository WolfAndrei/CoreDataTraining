//
//  EmployeeInformation+CoreDataProperties.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeInformation> {
        return NSFetchRequest<EmployeeInformation>(entityName: "EmployeeInformation")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var taxId: String?
    @NSManaged public var employee: Employee?

}
