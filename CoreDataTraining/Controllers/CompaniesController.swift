//
//  ViewController.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    let cellId = "CellID"
    var companies = [Company]()
    
    //MARK: - VIEW LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = .darkBlueColor
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        title = "Companies"
        setupNavBarAppearance()
        setupBarButtonItem()
        setupPlusBarButton(selector: #selector(handleAdd))
        fetchCompanies()
    }
    
    //MARK: - UI ELEMENTS
    
    //MARK: - TABLE VIEW DATA SOURCE AND DELEGATE METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .headerLightBlueColor
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        let attributes: [NSAttributedString.Key : Any] = [.underlineStyle : NSUnderlineStyle.single.rawValue, .font : UIFont.boldSystemFont(ofSize: 18)]
        let attributedText = NSMutableAttributedString(string: "\n \nNo companies available", attributes: attributes)
        attributedText.append(NSAttributedString(string: "\n \n \nPlease create some companies by using the Add button near the top", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular) ]))
        
        label.attributedText = attributedText
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count != 0 ? 0 : 150
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.editAction(at: indexPath)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let company = self.companies[indexPath.row]
            
            self.companies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStack.shared.managedContext.delete(company)
            CoreDataStack.shared.saveContext()
        }
        
        editAction.backgroundColor = .darkBlueColor
        deleteAction.backgroundColor = .lightRedColor
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesVC = EmployeesController()
        employeesVC.company = companies[indexPath.row]
        navigationController?.pushViewController(employeesVC, animated: true)
        
    }
    
    //MARK: - CUSTOM METHOD
    
    fileprivate func editAction(at indexPath: IndexPath) {
        let editViewController = CreateViewController()
        editViewController.company = companies[indexPath.row]
        editViewController.delegate = self
        let navigationController = CustomNavigationController(rootViewController: editViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    fileprivate func fetchCompanies() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            self.companies = try CoreDataStack.shared.managedContext.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Failed to fetch data \(error)")
        }
        
    }
    
    fileprivate func setupBarButtonItem() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItems = [
        UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
        UIBarButtonItem(title: "Nested updates", style: .plain, target: self, action: #selector(doNestedUpdate))
        ]
    }
    
    //MARK: - ACTIONS
    
    @objc func doNestedUpdate() {
        DispatchQueue.global(qos: .background).async {
            
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataStack.shared.managedContext
            //execute updates
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach {
                    $0.name = "ABS: \($0.name ?? "")"
                }
                do {
                    try privateContext.save()
                    //after save
                    DispatchQueue.main.async {
                        CoreDataStack.shared.saveContext()
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
    }

    
    @objc func handleReset() {
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try CoreDataStack.shared.managedContext.execute(batchDeleteRequest)
            var indexPathesToRemove = [IndexPath]()
            companies.enumerated().forEach{
                indexPathesToRemove.append(IndexPath(item: $0.offset, section: 0))
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathesToRemove, with: .left)
        } catch let error as NSError? {
            print("Unable to delete all companies: \(error!)")
        }
        
        
    }
    
    @objc func handleAdd() {
        let createVC = CreateViewController()
        let navController = CustomNavigationController(rootViewController: createVC)
        navController.modalPresentationStyle = .fullScreen
        createVC.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
}

//MARK: - EXTENSIONS

extension CompaniesController: CreateViewControllerDelegate {
   
    func didEditCompany(_ company: Company) {
        let index = companies.firstIndex(of: company)!
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func didAddNewCompany(_ company: Company) {
        companies.append(company)
        let indexPath = IndexPath(item: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    

    
}


/*
@objc func doWork() {
    
    //GCD - Grand central dispatch
    
    CoreDataStack.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
        
        (0...5).forEach { (value) in
            let company = Company(context: backgroundContext)
            company.name = String(value)
        }
        
        do {
            try backgroundContext.save()
            DispatchQueue.main.async {
                
                self.fetchCompanies()
                
            }


        } catch {
            print(error)
        }
        
    }
    
}


//Tricky updates CORE DATA
@objc func doUpdates() {
    
    CoreDataStack.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
        
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            let companies = try backgroundContext.fetch(fetchRequest)
            companies.forEach{print($0.name)
                $0.name = "C: \($0.name ?? "")"
            }
            
            do {
                try backgroundContext.save()
                //update the ui
                DispatchQueue.main.async {
                    
                    CoreDataStack.shared.managedContext.reset()
                    self.fetchCompanies()
                    
                    
                    
                }
                
                
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
        
    }
    
    
}

*/
