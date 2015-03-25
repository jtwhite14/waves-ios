//
//  WavesViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import HanekeSwift
import CoreData

@objc protocol PresentWaveDelegate{
    func presentWave(wave:ManagedWave, animated:Bool)
    func presentWave(waveIdentifier:NSString, newSessionIdentifier:NSString, newImage:UIImage, animated:Bool)
}

class WavesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PresentWaveDelegate {

    var waves: [Wave]! = []
    var refreshControl:UIRefreshControl!
    var locationClient:LocationClient!
    var firstLoad:Bool = true
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadCurrentUser", name: "current-user-changed", object: nil)
        
        collectionView!.registerNib(UINib(nibName: "WaveCell", bundle: nil), forCellWithReuseIdentifier: "WaveViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "loadWaves", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
    }
    
    func checkForAuth() {
        if (!CredentialStore.sharedStore().isLoggedIn()) {
            displayLogin()
        } else {
            if (firstLoad) {
                User.getCurrentUserWithCompletion(nil)
                self.locationClient = LocationClient.sharedClient()
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadWaves", name: "location-updated", object: nil)
                firstLoad = false
            }
        }
    }
    
    func loadCurrentUser() {
            let user = CredentialStore.sharedStore().currentUser
            self.userNameLabel.text = user.name
            self.avatarImageView.hnk_setImageFromURL(NSURL(string:user.avatarUrl)!, placeholder:UIImage(named: "import-photo-icon"))
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
            self.fetchedResultsController.performFetch(nil)
            if (self.numberOfWaves() == 0) {
                self.collectionView!.hidden = true
            } else {
                self.collectionView!.hidden = false
            }
            
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "location-updated", object: nil)
    }
    
    func numberOfWaves() -> (Int) {
        var count : Int!
        if let s = self.fetchedResultsController.sections as? [NSFetchedResultsSectionInfo] {
            count = s[0].numberOfObjects
        }
        return count
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let fetchRequest = NSFetchRequest(entityName: "Wave")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.performFetch(nil)
        
        return controller
    }()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.numberOfWaves()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WaveViewCell", forIndexPath: indexPath) as WaveCell
        //let wave = waves[indexPath.row] as Wave
        let wave = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedWave
        
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
        let wave = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedWave
        self.presentWave(wave, animated: true)
    }
    
    func presentWave(wave:ManagedWave, animated:Bool) {
        let waveVC = WaveViewController(nibName: "WaveViewController", bundle: nil)
        waveVC.wave = wave
        self.navigationController?.pushViewController(waveVC, animated: animated)
    }
    
    func presentWave(waveIdentifier:NSString, newSessionIdentifier:NSString, newImage:UIImage, animated:Bool) {
        self.loadWaves()
        let waveVC = WaveViewController(nibName: "WaveViewController", bundle: nil)
        waveVC.wave = findWaveByIdentifier(waveIdentifier)
        waveVC.newSessionIdentifier = newSessionIdentifier
        waveVC.newSessionImage = newImage
        self.navigationController?.pushViewController(waveVC, animated: animated)
    }
    
    func findWaveByIdentifier(identifier:NSString) -> (ManagedWave)  {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let fetchRequest = NSFetchRequest(entityName: "Wave")
        
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let wave = appDelegate.managedObjectContext.executeFetchRequest(fetchRequest, error: nil)?.first as ManagedWave
        return wave
        
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
            
            
            Session.createSession(nil, withCompletion: { (session:Session!) in
               
                WavesImageUploader.sharedClient().uploadImage(picked, withCompletion: { (successResult:[NSObject : AnyObject]!) in
                   Session.uploadImage(successResult, withSessionID: session.identifier, withCompletion:nil)
                })

                let editSessionVC = EditSessionViewController(nibName: "EditSessionViewController", bundle: nil)
                editSessionVC.session = newSession
                editSessionVC.sessionPhoto = picked
                editSessionVC.createdSessionIdentifier = session.identifier
                editSessionVC.delegate = self
                picker.dismissViewControllerAnimated(true, completion: {
                    self.presentViewController(editSessionVC, animated: true, completion: nil)
                })
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
