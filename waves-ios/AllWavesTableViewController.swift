//
//  AllWavesTableViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/10/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit
import Mantle

class AllWavesTableViewController: UITableViewController {
    
    var waves: [Wave]! = []
    var delegate:SetWaveDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Waves"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:"cancel")
        
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: false)
    
        
//        let nibName = UINib(nibName: "WaveNameCell", bundle:nil)
//        self.tableView.registerNib(nibName, forCellReuseIdentifier: "WaveNameCellIdentifier")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "waveNameIdentifier")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    func cancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.numberOfWaves()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("waveNameIdentifier", forIndexPath: indexPath) as UITableViewCell
        let wave = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedWave
        cell.textLabel?.text = wave.slug
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let managedWave = self.fetchedResultsController.objectAtIndexPath(indexPath) as ManagedWave
        let wave = MTLManagedObjectAdapter.modelOfClass(Wave.self, fromManagedObject: managedWave, error: nil) as Wave
        self.delegate?.setWave(wave)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
