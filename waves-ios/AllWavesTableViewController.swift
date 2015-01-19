//
//  AllWavesTableViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/10/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

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
        self.loadWaves()
    }
    
    func loadWaves() {
        Wave.getWaves({(waves:[AnyObject]!)  in
            self.waves = waves as? [Wave]
            self.tableView.reloadData()
        })
    }
    
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
        return waves.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("waveNameIdentifier", forIndexPath: indexPath) as UITableViewCell
        let wave : Wave = self.waves[indexPath.row] as Wave
        cell.textLabel?.text = wave.slug
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let wave : Wave = self.waves[indexPath.row] as Wave
        self.delegate?.setWave(wave)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
