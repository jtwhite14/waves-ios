//
//  CreateAccountViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/15/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signupButton.setImage(UIImage(named: "signup-inactive-btn"), forState: UIControlState.Disabled)
        self.signupButton.enabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        hideKeyboard()
        
        let params:NSDictionary = [ "registration" : [
            "name" : self.nameTextField.text,
            "email" : self.emailTextField.text,
            "password" : self.passwordTextField.text
        ]]
        
        User.createCurrentUser(params, withCompletion: { (user:User!) in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            NSLog("ok")
        })
    }
    
    @IBAction func selectAvatar(sender: AnyObject) {
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if ((self.nameTextField.text.utf16Count > 0) && (self.emailTextField.text.utf16Count > 0) && (self.passwordTextField.text.utf16Count > 0)) {
            self.signupButton.enabled = true
        } else {
            self.signupButton.enabled = false
        }
    }
    
    
    @IBAction func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        nameTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)

    }

}
