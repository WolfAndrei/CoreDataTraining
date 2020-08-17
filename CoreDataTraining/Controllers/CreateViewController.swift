//
//  CreateViewController.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

protocol CreateViewControllerDelegate: class {
    func didAddNewCompany(_ company: Company)
    func didEditCompany(_ company: Company)
}

class CreateViewController: UIViewController {
    
    //MARK: - PROPERTIES
    
    weak var delegate: CreateViewControllerDelegate?
    var company: Company? {
        didSet {
            if let company = company {
                nameTextField.text = company.name
                if let imageData = company.imageData {
                    selectPhotoView.image = UIImage(data: imageData)
                }
                guard let foundationDate = company.date else {return}
                datePicker.date = foundationDate
            }
        }
    }
    
    //MARK: - VIEW LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlueColor
        setupNavBarAppearance()
        setupBarButtonItem()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCircularImage()
    }
    //MARK: - UI ELEMENTS
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let datePicker: UIDatePicker = {
       let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    let backgroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .headerLightBlueColor
        bgView.layer.cornerRadius = 10
        bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return bgView
    }()
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter name"
        return tf
    }()
    
    lazy var selectPhotoView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "select_photo_empty")
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        return iv
    }()
    
    let selectPhotoLabel: UILabel = {
      let label = UILabel()
        label.text = "Select Photo"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupCircularImage() {
        
        selectPhotoView.clipsToBounds = true
        selectPhotoView.layer.cornerRadius = selectPhotoView.frame.height / 2
        selectPhotoView.layer.borderColor = selectPhotoView.image != #imageLiteral(resourceName: "select_photo_empty") ? UIColor.darkBlueColor.cgColor : UIColor.clear.cgColor
        selectPhotoView.layer.borderWidth = 1
    }
    
    fileprivate func setupBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    fileprivate func setupLayout() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(selectPhotoView)
        backgroundView.addSubview(selectPhotoLabel)
        backgroundView.addSubview(nameLabel)
        backgroundView.addSubview(nameTextField)
        backgroundView.addSubview(datePicker)
        
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: 0, height: 400))
        
        selectPhotoView.anchor(top: backgroundView.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 150, height: 150), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        selectPhotoView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
        selectPhotoLabel.anchor(top: selectPhotoView.bottomAnchor, leading: backgroundView.leadingAnchor, bottom: nil, trailing: backgroundView.trailingAnchor, size: .init(width: 0, height: 40), padding: .init(top: 20, left: 10, bottom: 0, right: 10))
        selectPhotoLabel.layer.cornerRadius = 5
        
        nameLabel.anchor(top: selectPhotoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 100, height: 50), padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        nameTextField.anchor(top: selectPhotoLabel.bottomAnchor, leading: nameLabel.trailingAnchor, bottom: nil, trailing: backgroundView.trailingAnchor, size: .init(width: 0, height: 50))
        
        datePicker.anchor(top: nameTextField.bottomAnchor, leading: backgroundView.leadingAnchor, bottom: nil, trailing: backgroundView.trailingAnchor, size: .init(width: 0, height: 100))
    }
    
    fileprivate func createCompany() {
        
        if let companyName = nameTextField.text, !companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            let tuple = Company.createNewCompany(name: companyName, foundationDate: datePicker.date, selectPhotoView: selectPhotoView)
            if let error = tuple.1 {
                presentAlertController(title: "Error", message: error.localizedDescription)
            } else {
                dismiss(animated: true) {
                    self.delegate?.didAddNewCompany(tuple.0!)
                }
            }
        } else {
            presentAlertController(title: "Blank company name", message: "Enter a company name.")
        }
    }
    
    fileprivate func editCompany() {
        if let companyName = nameTextField.text, !companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let company = self.company else {return}
            let tuple = Company.editCompany(company, newName: companyName, newFoundationDate: datePicker.date, newCompanyImageView: selectPhotoView)
            if let error = tuple.1 {
                presentAlertController(title: "Error", message: error.localizedDescription)
            } else {
                dismiss(animated: true) {
                    self.delegate?.didEditCompany(tuple.0!)
                }
            }
        } else {
            presentAlertController(title: "Blank company name", message: "Enter a company name.")
        }
    }
    
    //MARK: - ACTIONS
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            editCompany()
        }
    }
    
    @objc func handleTap() {
        print("tapped")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        picker.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .lightRedColor
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        picker.navigationController?.navigationBar.standardAppearance = navBarAppearance
        picker.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        picker.navigationController?.navigationBar.isTranslucent = false
        present(picker, animated: true, completion: nil)
    }
    
}


extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let pickedImage = info[.editedImage] as? UIImage
        
        
        
        dismiss(animated: true) {
            self.selectPhotoView.image = pickedImage
        }
        
        
        
    }
}


/*
 
 let en = NSEntityDescription.insertNewObject(forEntityName: "Company", into: CoreDataStack.shared.managedContext)
 en.setValue("someText", forKey: "name")
 
 IS EQUAL TO
 
 let company = Company(entity: Company.entity(), insertInto: CoreDataStack.shared.managedContext)
 company.name = companyName
 
 
 
 */
