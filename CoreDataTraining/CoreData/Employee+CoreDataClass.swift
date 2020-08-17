//
//  Employee+CoreDataClass.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//
//

import UIKit
import CoreData

public class Employee: NSManagedObject {
    
    enum EmployeeEnum: Int, CaseIterable {
        case executive, seniorManager, staff
        
        var description: String {
            switch self {
            case .executive:
                return "Executive"
            case .seniorManager:
                return "Senior Manager"
            case .staff:
                return "Staff"
            }
        }
        
    }
    
    
//    static func returnEnumObject(employee: Employee) -> EmployeeEnum? {
//        switch employee.type {
//        case "Executive":
//            return EmployeeEnum(rawValue: 0)
//        case "Senior Manager":
//            return EmployeeEnum(rawValue: 1)
//        case "Staff":
//            return EmployeeEnum(rawValue: 2)
//        default :
//            return nil
//        }
//    }
    
    static func createEmployee(with name: String, birthday: Date, employeeType: String, company: Company) -> (Employee?, Error?) {
        
        let employee = Employee(entity: Employee.entity(), insertInto: CoreDataStack.shared.managedContext)
        
        let employeeInfo = EmployeeInformation(entity: EmployeeInformation.entity(), insertInto: CoreDataStack.shared.managedContext)
        employeeInfo.taxId = "456"
        employeeInfo.birthday = birthday
        
        employee.name = name
        employee.type = employeeType
        
        employee.emplyeeInfo = employeeInfo
        employee.company = company
        
        
        do {
            try CoreDataStack.shared.managedContext.save()
            return (employee, nil)
        } catch {
            print("Failed to create an employee:", error)
            return (nil, error)
        }
        
    }
    
    
}
