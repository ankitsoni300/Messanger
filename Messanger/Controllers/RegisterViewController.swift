//
//  RegisterViewController.swift
//  Messanger
//
//  Created by imart on 05/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private var emailField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private var firstNameField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private var lastNameField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private var passwordField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private var registrationButton : UIButton = {
        let button = UIButton()
        button.setTitle("Registration", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight : .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Registration"
        self.registrationButton.addTarget(self, action: #selector(btnRegistrationTapped), for: .touchUpInside)
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        //Add View
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.emailField)
        self.scrollView.addSubview(self.passwordField)
        self.scrollView.addSubview(self.registrationButton)
        self.scrollView.addSubview(self.firstNameField)
        self.scrollView.addSubview(self.lastNameField)
        
        self.imageView.isUserInteractionEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapChangeProfilePic))
        self.imageView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        let size = self.scrollView.width / 3
        self.imageView.frame = CGRect(x: (self.scrollView.width - size) / 2,
                                      y: 20,
                                      width: size,
                                      height: size)
        self.imageView.layer.cornerRadius = self.imageView.width / 2.0
        self.firstNameField.frame = CGRect(x: 30,
                                       y: self.imageView.bottom + 10,
                                       width: self.scrollView.width - 60,
                                       height: 52)
        
        self.lastNameField.frame = CGRect(x: 30,
                                       y: self.firstNameField.bottom + 10,
                                       width: self.scrollView.width - 60,
                                       height: 52)
        
        self.emailField.frame = CGRect(x: 30,
                                       y: self.lastNameField.bottom + 10,
                                       width: self.scrollView.width - 60,
                                       height: 52)
        
        self.passwordField.frame = CGRect(x: 30,
                                          y: self.emailField.bottom + 10,
                                          width: self.scrollView.width - 60,
                                          height: 52)
        
        self.registrationButton.frame = CGRect(x: 30,
                                        y: self.passwordField.bottom + 20,
                                        width: self.scrollView.width - 60,
                                        height: 52)
        
    }
    
    @objc private func didTapChangeProfilePic(){
        self.openPhotoSelectSheet()
    }
    
    @objc private func btnRegistrationTapped(){
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            password.count >= 6
            else {
                alertUserRegistrationError()
                return
        }
    }
    
    func alertUserRegistrationError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to create new account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension RegisterViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.firstNameField{
            self.lastNameField.becomeFirstResponder()
        }else if textField == self.lastNameField{
            self.emailField.becomeFirstResponder()
        }else if textField == self.emailField{
            self.passwordField.becomeFirstResponder()
        }else if textField == self.passwordField{
            self.passwordField.resignFirstResponder()
            self.btnRegistrationTapped()
        }
        
        return true
    }
    
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openPhotoSelectSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture"
            , message: "How would you like to select a picture?",
              preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self]_ in
            self?.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self]_ in
            self?.openGallery()
        }))
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.imageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.cameraCaptureMode = .photo
        self.present(vc, animated: true, completion: nil)
    }
    
    func openGallery() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
}
