//
//  WavesViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

@objc protocol PresentWaveDelegate{
    func presentWave(wave:Wave, animated:Bool)
}

class WavesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PresentWaveDelegate {

    var waves: [Wave]! = []
    var refreshControl:UIRefreshControl!
    var locationClient:LocationClient!
    var authChecked:Bool! = false
    var welcomeShown:Bool! = false
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //collectionView!.registerClass(WaveCell.self, forCellWithReuseIdentifier: "WaveViewCell")
        collectionView!.registerNib(UINib(nibName: "WaveCell", bundle: nil), forCellWithReuseIdentifier: "WaveViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "loadWaves", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func checkForAuth() {
        if (!CredentialStore.sharedStore().isLoggedIn()) {
            displayLogin()
        } else {
            if (!authChecked) {
                self.locationClient = LocationClient.sharedClient()
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadWaves", name: "location-updated", object: nil)
                self.authChecked = true
            }
            User.getCurrentUserWithCompletion({ (user:User!) in
                self.userNameLabel.text = user.name
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        checkForAuth()
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
    }
    
    func loadWaves() {
        
        let params : NSDictionary = [ "latitude" : LocationClient.sharedClient().currentLocation.latitude , "longitude" : LocationClient.sharedClient().currentLocation.longitude ]
        
        Wave.getClosestWaves(params, withCompletion: {(waves:[AnyObject]!)  in
            self.waves = waves as? [Wave]
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "location-updated", object: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return waves.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WaveViewCell", forIndexPath: indexPath) as WaveCell
        let wave = waves[indexPath.row] as Wave
        
        cell.configureWave(wave)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        // NOTE: here is where we say we want cells to use the width of the collection view
        let width = (collectionView.bounds.size.width - 5) / 2
        
        // NOTE: here is where we ask our sizing cell to compute what height it needs
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let wave = waves[indexPath.row] as Wave
        self.presentWave(wave, animated: true)
    }
    
    func presentWave(wave:Wave, animated:Bool) {
        let waveVC = WaveViewController(nibName: "WaveViewController", bundle: nil)
        waveVC.wave = wave
        self.navigationController?.pushViewController(waveVC, animated: animated)
    }
    
    @IBAction func newSession(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.navigationBarHidden = true;
        picker.toolbarHidden = true;
        picker.allowsEditing = false;
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var newSession = Session()
        
        
        let picked : UIImage =  info[UIImagePickerControllerOriginalImage] as UIImage
        let url : NSURL = info["UIImagePickerControllerReferenceURL"] as NSURL
        
        let resultBlock : ALAssetsLibraryAssetForURLResultBlock = { (myasset: ALAsset!) in
            
            if ((myasset.valueForProperty(ALAssetPropertyLocation)) != nil) {
                let location : CLLocation! = myasset.valueForProperty(ALAssetPropertyLocation) as CLLocation
                newSession.latitude = location.coordinate.latitude
                newSession.longitude = location.coordinate.longitude
            }
            
            if ((myasset.valueForProperty(ALAssetPropertyDate)) != nil) {
                let timestamp : NSDate! = myasset.valueForProperty(ALAssetPropertyDate) as NSDate
                NSLog(timestamp.description)
                
                newSession.timestamp = timestamp
            }
            
            
            let editSessionVC = EditSessionViewController(nibName: "EditSessionViewController", bundle: nil)
            editSessionVC.session = newSession
            editSessionVC.sessionPhoto = picked
            editSessionVC.delegate = self
            
            
            Session.uploadImageForSession(picked, withCompletion: nil)
            
            picker.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(editSessionVC, animated: true, completion: nil)
            })
        }
        
        let failureBlock : ALAssetsLibraryAccessFailureBlock = { (error: NSError!) in
            NSLog("Can not get asset - %@", error.localizedDescription)
        }
        
        
        let assetsLibrary = ALAssetsLibrary()
        assetsLibrary.assetForURL(url, resultBlock: resultBlock, failureBlock: failureBlock)
    }
    
    
    @IBAction func showMap(sender: AnyObject) {
        let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
        let MapNav = UINavigationController(rootViewController: mapVC)
        self.presentViewController(MapNav, animated: true, completion: nil)
    }
    
    @IBAction func showSettions(sender: AnyObject) {
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        self.presentViewController(settingsNav, animated: true, completion: nil)
    }
    
    func displayLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let loginNav = UINavigationController(rootViewController: loginVC)
        self.presentViewController(loginNav, animated: false, completion: nil)
    }
}
