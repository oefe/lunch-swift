//
//  ViewController.swift
//  Lunch
//
//  Created by Martina Oefelein on 14.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet
    var tableView: UITableView!
    var order = Order(today: NSDate())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
        loadOrder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchTableViewCell
        
        cell.textLabel?.text = "Hello \(indexPath.section)-\(indexPath.row)"
        
        cell.toggle.on = order.valueForWeekIndex(indexPath.section, dayIndex: indexPath.row)
        cell.toggle.enabled = indexPath.section > 0 && !order.alreadyOrdered
        cell.toggle.tag = indexPath.row
        
        return cell
    }
    
    @IBAction
    func valueChanged(sender: UISwitch) {
        println("Changing day \(sender.tag) to \(sender.on)")
        order.next[sender.tag] = sender.on
        saveOrder()
    }
    
    private func saveOrder() {
        let json = order.asJsonObject()
        var error: NSErrorPointer = nil
        if let data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: error) {
            data.writeToURL(dataFileUrl(), atomically: true)
        }
    }
    
    private func loadOrder() {
        var error: NSErrorPointer = nil
        if let data = NSData(contentsOfURL:dataFileUrl()) {
            if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: error) as? NSDictionary {
                order = Order(today: NSDate(), withJsonObject: json)
            }
        }
    }
    
    private func dataFileUrl() -> NSURL {
        let fm = NSFileManager()
        var error: NSErrorPointer = nil
        let url = fm.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: error)
        return url!
    }
}

