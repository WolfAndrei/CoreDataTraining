//
//  EmployeesController.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 14.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    //MARK: - PROPERTIES
    let cellID = "CellID"
    var company: Company? {
        didSet {
            if let company = company {
                title = company.name
            }
        }
    }
    
    var executiveEmployees = [Employee]()
    var seniorManagerEmployees = [Employee]()
    var staffEmployees = [Employee]()
    
    private func employessCount(for priority: Employee.EmployeeEnum) -> [Employee] {
        switch priority {
        case .executive:
            return executiveEmployees
        case .seniorManager:
            return seniorManagerEmployees
        case .staff:
            return staffEmployees
        }
    }
    
    private func priorityForSectionIndex(_ index: Int) -> Employee.EmployeeEnum? {
      return Employee.EmployeeEnum(rawValue: index)
    }
    
    //MARK: - VIEW LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        setupBarButtonItem()
        setupPlusBarButton(selector: #selector(handleAdd))
        fetchEmployees()
    }
    
    //MARK: - TABLE VIEW DATA SOURCE AND DELEGATE METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Employee.EmployeeEnum.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return employessCount(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let employees = employessCount(for: priority)
            let employee = employees[indexPath.row]
            cell.backgroundColor = .lightBlueColor
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = .boldSystemFont(ofSize: 15)
            cell.textLabel?.text = employee.name!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = CustomLabel()
        label.backgroundColor = .headerLightBlueColor
        label.font = .boldSystemFont(ofSize: 16)
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            title = priority.description
        }
        label.text = title
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}

        executiveEmployees = companyEmployees.filter { $0.type == Employee.EmployeeEnum.executive.description}
        seniorManagerEmployees = companyEmployees.filter { $0.type == Employee.EmployeeEnum.seniorManager.description}
        staffEmployees = companyEmployees.filter { $0.type == Employee.EmployeeEnum.staff.description}
    }
    
    fileprivate func setupBarButtonItem() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - ACTIONS
    
    @objc func handleAdd() {
        let createEmployeeVC = CreateEmployeeController()
        let navContr = CustomNavigationController(rootViewController: createEmployeeVC)
        createEmployeeVC.delegate = self
        createEmployeeVC.company = company
        navContr.modalPresentationStyle = .fullScreen
        present(navContr, animated: true, completion: nil)
        
    }
    
}

//MARK: - EXTENSIONS

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(_ employee: Employee) {
        
        var sectionDefinition: Employee.EmployeeEnum?
        
        switch employee.type {
        case Employee.EmployeeEnum.executive.description:
            sectionDefinition = Employee.EmployeeEnum.executive
            executiveEmployees.append(employee)
        case Employee.EmployeeEnum.seniorManager.description:
            sectionDefinition = Employee.EmployeeEnum.seniorManager
            seniorManagerEmployees.append(employee)
        case Employee.EmployeeEnum.staff.description:
            sectionDefinition = Employee.EmployeeEnum.staff
            staffEmployees.append(employee)
        default:
            ()
        }
        
        guard let section = Employee.EmployeeEnum.allCases.firstIndex(of: sectionDefinition!) else {return}
        let row = employessCount(for: sectionDefinition!).count
        
        let indexPath = IndexPath(row: row - 1, section: section)
        
        tableView.insertRows(at: [indexPath], with: .middle)
    }
    
    
}
