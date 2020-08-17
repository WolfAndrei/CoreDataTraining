//
//  CreateEmployeeController.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 14.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate: class {
    func didAddEmployee(_ employee: Employee)
}


class CreateEmployeeController: UIViewController {
    
    //MARK: - PROPERTIES
    
    weak var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Employee"
        setupNavBarAppearance()
        setupLayout()
        setupBarButtonItem()
    }
    
    //MARK: - UI ELEMENTS
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter name"
        return tf
    }()
    
    let dobLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        return label
    }()
    
    let dobField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "MM/dd/yyyy"
        return tf
    }()
    
    let employeeType: UISegmentedControl = {
       let sc = UISegmentedControl(
        items:[
            Employee.EmployeeEnum.executive.description,
            Employee.EmployeeEnum.seniorManager.description,
            Employee.EmployeeEnum.staff.description
       ])
        
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleChange(sender:)), for: .valueChanged)
        return sc
    }()
    
    let backgroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .headerLightBlueColor
        bgView.layer.cornerRadius = 10
        bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return bgView
    }()
    

    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .darkBlueColor
        
        view.addSubview(backgroundView)
        
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 200))
        
        
        backgroundView.vStack(
            views:
            backgroundView.hStack(views: nameLabel.withWidth(100), nameTextField, spacing: 20),
            backgroundView.hStack(views: dobLabel.withWidth(100), dobField, spacing: 20),
            employeeType, distribution: .fillEqually, alignment: .fill, spacing: 10).withMargins(.init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    fileprivate func createEmployee() {
        if let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let company = self.company else {return}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            guard let birthdayText = dobField.text, !birthdayText.isEmpty else {
                presentAlertController(title: "Blank birthday", message: "Please enter a valid birthday.", acceptAction: true)
                return
            }
            guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
                presentAlertController(title: "Bad format birthday", message: "Please enter a valid birthday.", acceptAction: true)
                return
            }
            
            guard let employeeType = self.employeeType.titleForSegment(at: self.employeeType.selectedSegmentIndex) else {return}
            
            let tuple = Employee.createEmployee(with: name, birthday: birthdayDate, employeeType: employeeType, company: company)
            
            if let error = tuple.1 {
                presentAlertController(title: "Failed to create employee", message: error.localizedDescription)
            } else {
                dismiss(animated: true) {
                    self.delegate?.didAddEmployee(tuple.0!)
                }
            }
        } else {
            presentAlertController(title: "Blank name", message: "Please enter a name.")
        }
    }

    
    //MARK: - ACTIONS
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
       createEmployee()
        
    }
    
    @objc func handleChange(sender: UISegmentedControl) {
        
        
    }
    
}
