//
//  Company+CoreDataClass.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//
//

import UIKit
import CoreData


public class Company: NSManagedObject {
    
    static func createNewCompany(name: String, foundationDate: Date, selectPhotoView: UIImageView) -> (Company?, Error?) {
        
        let company = Company(entity: Company.entity(), insertInto: CoreDataStack.shared.managedContext)
        company.name = name
        company.date = foundationDate
        
        if let companyImageData = selectPhotoView.image {
            if selectPhotoView.image !=  #imageLiteral(resourceName: "select_photo_empty") {
                company.imageData = companyImageData.pngData()
            }
        }
        do {
            try CoreDataStack.shared.managedContext.save()
            return (company, nil)
        } catch {
            return (nil, error)
        }
    }
    
    static func editCompany(_ company: Company, newName: String, newFoundationDate: Date, newCompanyImageView: UIImageView) -> (Company?, Error?) {
        company.name = newName
        company.date = newFoundationDate
        if let companyImage = newCompanyImageView.image {
            company.imageData = companyImage.pngData()
        }
        do {
            try CoreDataStack.shared.managedContext.save()
            return (company, nil)
        } catch {
            print("Failed to edit the company")
            return (nil, error)
        }
    }
    
}

