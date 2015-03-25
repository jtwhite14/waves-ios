//
//  LoginViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/15/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    var welcomeTourShown:Bool! = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loginButton.setImage(UIImage(named: "login-inactive-btn"), forState: UIControlState.Disabled)
        self.loginButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!welcomeTourShown) {
            welcomeTourShown = true
            let welcomeVC = WelcomePageViewController(nibName: "WelcomePageViewController", bundle: nil)
            let navVC = UINavigationController(rootViewController: welcomeVC)
            self.presentViewController(navVC, animated: false, completion:nil)
        }
    }

    @IBAction func login(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hideKeyboard()
        
        let params:NSDictionary = [ "user_login" : [
            "email" : self.emailTextField.text,
            "password" : self.passwordTextField.text
        ]]
        
        User.login(params, withCompletion: { (user:User!, error:NSError!) in
            hud.hide(true)
            if ((error) != nil) {
                UIAlertView(title: "Oops", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func displayCreateAccount(sender: AnyObject) {
        let createVC = CreateAccountViewController(nibName: "CreateAccountViewController", bundle: nil)
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if ((self.emailTextField.text.utf16Count > 0) && (self.passwordTextField.text.utf16Count > 0)) {
            self.loginButton.enabled = true
        } else {
            self.loginButton.enabled = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }

}
