//
//  Employee+CoreDataProperties.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var emplyeeInfo: EmployeeInformation?
    @NSManaged public var employeeAddress: Address?
    @NSManaged public var company: Company?

}
