//
//  CreateAccountViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/15/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import DZNPhotoPickerController
import HanekeSwift
import MBProgressHUD

class CreateAccountViewController: UIViewController {

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signupButton.setImage(UIImage(named: "signup-inactive-btn"), forState: UIControlState.Disabled)
        self.signupButton.enabled = false
        
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width / 2
        self.avatarView.clipsToBounds = true

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
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hideKeyboard()
        
        let params: NSDictionary = [ "registration" : [
            "name" : "\(self.nameTextField.text)",
            "email" : "\(self.emailTextField.text)",
            "password" : "\(self.passwordTextField.text)"
        ]]
        
        User.createCurrentUser(params, withImage:self.avatarView.image, withCompletion: { (user:User!, error:NSError!) in
            hud.hide(true)
            if ((error) != nil) {
                UIAlertView(title: "Oops", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func selectAvatar(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.cropMode = DZNPhotoEditorViewControllerCropMode.Circular
        
        picker.finalizationBlock = { (picker:UIImagePickerController!, info:[NSObject : AnyObject]!) in
            self.avatarView.image = info[UIImagePickerControllerEditedImage] as? UIImage
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        picker.cancellationBlock = { (picker:UIImagePickerController!) in
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
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
