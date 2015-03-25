//
//  SettingsViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/18/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import DZNPhotoPickerController
import HanekeSwift
import MBProgressHUD

class SettingsViewController: UIViewController {

    var user:User!
    var newAvatar:UIImage! = nil
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width / 2
        self.avatarView.clipsToBounds = true
        
        loadCurrentUser()
    }
    
    func loadCurrentUser() {
        if((CredentialStore.sharedStore().currentUser) != nil) {
            self.user = CredentialStore.sharedStore().currentUser
            self.nameLabel.text = user.name
            self.avatarView.hnk_setImageFromURL(NSURL(string:user.avatarUrl)!, placeholder:UIImage(named: "import-photo-icon"))
        } else {
            User.getCurrentUserWithCompletion({ (user:User!) in
                self.user = user
                self.nameLabel.text = user.name
                self.avatarView.hnk_setImageFromURL(NSURL(string:user.avatarUrl)!, placeholder:UIImage(named: "import-photo-icon"))
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func updateAvatar(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.cropMode = DZNPhotoEditorViewControllerCropMode.Circular
        
        picker.finalizationBlock = { (picker:UIImagePickerController!, info:[NSObject : AnyObject]!) in
            self.newAvatar = info[UIImagePickerControllerEditedImage] as? UIImage
            self.avatarView.image = self.newAvatar
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        picker.cancellationBlock = { (picker:UIImagePickerController!) in
           picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateUser() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let params: NSDictionary = [ "user" : [ "name" : self.nameLabel.text ]]
        self.user.updateUser(params, withImage: self.newAvatar, withCompletion: { (user:User!) in
            hud.hide(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    
    @IBAction func logout() {
        CredentialStore.sharedStore().logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.nameLabel.resignFirstResponder()
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func displayContactUs(sender: AnyObject) {
        let contactVC = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
