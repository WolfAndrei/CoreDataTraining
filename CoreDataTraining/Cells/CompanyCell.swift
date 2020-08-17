//
//  CompanyCell.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 14.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    var company: Company? {
        didSet {
            if let company = company {
                if company.date != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    let dateString = dateFormatter.string(from: company.date!)
                    
                    companyLabel.text = "\(company.name!) - Founded \(dateString)"
                } else {
                    companyLabel.text = company.name
                }
                if let imageData = company.imageData {
                    companyImage.image = UIImage(data: imageData)
                } else {
                    companyImage.image = #imageLiteral(resourceName: "select_photo_empty")
                }
            }
        }
    }
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        companyImage.layer.cornerRadius = companyImage.frame.height / 2
        companyImage.layer.masksToBounds = true
    }
    
    //MARK: - UI ELEMENTS
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let companyImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.darkBlueColor.cgColor
        iv.layer.borderWidth = 1
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    //MARK: - Custom methods
    fileprivate func setupLayout() {
        backgroundColor = .lightBlueColor
        addSubview(companyLabel)
        addSubview(companyImage)
        
        companyImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 5, left: 20, bottom: 5, right: 0))
        companyImage.widthAnchor.constraint(equalTo: companyImage.heightAnchor).isActive = true
        
        companyLabel.anchor(top: topAnchor, leading: companyImage.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        
    }
}
