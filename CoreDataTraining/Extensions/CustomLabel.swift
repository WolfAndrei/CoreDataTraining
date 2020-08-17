//
//  CustomLabel.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 17.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: .init(top: 0, left: 16, bottom: 0, right: 0)))
    }
    
}
