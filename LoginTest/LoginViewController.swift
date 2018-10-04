//
//  LoginViewController.swift
//  LoginTest
//
//  Created by Руслан Акберов on 04.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        loginButton.layer.cornerRadius = 5
        loginButton.setBackgroundColor(color: .lightGray, forState: .disabled)
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnScrollView)))
        setImageInTheTextField()
    }
    
    func setImageInTheTextField() {
        passwordTextField.rightViewMode = .always
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.image = UIImage(named: "eye")
        imageView.tintColor = .lightGray
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnEyeImageView(recognizer:))))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        view.addSubview(imageView)
        passwordTextField.rightView = view
    }
    
    @objc func tapOnEyeImageView(recognizer: UITapGestureRecognizer) {
        guard let imageView = recognizer.view else { return }
        passwordTextField.isSecureTextEntry = passwordTextField.isSecureTextEntry == true ? false : true
        imageView.tintColor = imageView.tintColor == .lightGray ? .darkGray : .lightGray
    }
    
    @IBAction func emailTextFieldEditing(_ sender: UITextField) {
        handleLoginButtonState()
    }
    
    @IBAction func passwordTextFieldEditing(_ sender: UITextField) {
        handleLoginButtonState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.count ?? 0) < 41 || string == ""
    }
    
    func handleLoginButtonState() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if Validation.isValid(email: email) && Validation.isValid(password: password) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            Alert.showServerErrorAlert(on: self)
            self.activityIndicator.stopAnimating()
            self.loginButton.isEnabled = true
        }
    }
    
    //MARK: - Handle keyboard appearence and hiding
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 80, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func tapOnScrollView() {
        view.endEditing(true)
    }

}
