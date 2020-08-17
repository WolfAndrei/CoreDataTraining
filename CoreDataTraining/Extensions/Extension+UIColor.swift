//
//  Extension+UIColor.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let lightRedColor = UIColor.rgba(red: 247, green: 66, blue: 82, alpha: 1)
    static let darkBlueColor = UIColor.rgba(red: 9, green: 45, blue: 64, alpha: 1)
    static let lightBlueColor = UIColor.rgba(red: 48, green: 164, blue: 182, alpha: 1)
    static let headerLightBlueColor = UIColor.rgba(red: 218, green: 235, blue: 243, alpha: 1)
}
