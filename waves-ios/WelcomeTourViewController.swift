//
//  WelcomeTourViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/16/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class WelcomeTourViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var itemIndex: Int = 0
    var imageName: String! {
        didSet {
            if let imageView = self.imageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView!.image = UIImage(named: imageName)
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
