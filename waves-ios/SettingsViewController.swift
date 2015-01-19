//
//  SettingsViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/18/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var nameLabel: UITextField!
    
    @IBOutlet var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func updateAvatar(sender: AnyObject) {
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
