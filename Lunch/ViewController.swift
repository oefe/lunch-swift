//
//  ViewController.swift
//  Lunch
//
//  Created by Martina Oefelein on 14.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet
    var tableView: UITableView!
    
    @IBOutlet
    var sendButton: UIButton!
    
    var order = Order(today: NSDate())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
        loadOrder()
        updateSendButtonLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return order.weekLabel(section)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("switchCell")!
        
        cell.textLabel?.text = order.dayLabel(week: indexPath.section, day: indexPath.row)
        let toggle = UISwitch()
        
        toggle.on = order.valueForWeek(indexPath.section, day: indexPath.row)
        toggle.enabled = indexPath.section > 0 && !order.alreadyOrdered
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = toggle
        if indexPath.section == 0 && indexPath.row == order.currentDay {
            cell.backgroundColor = UIColor (hue: 0.111111, saturation: 0.6, brightness: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    @IBAction
    func valueChanged(sender: UISwitch) {
        print("Changing day \(sender.tag) to \(sender.on)")
        order.next[sender.tag] = sender.on
        saveOrder()
    }
    
    @IBAction
    func sendOrder(sender: UIButton) {
        if !order.alreadyOrdered {
            sendEmail()
        }
        order.alreadyOrdered = !order.alreadyOrdered
        saveOrder()
        tableView.reloadData()
        updateSendButtonLabel()
    }
    
    private func saveOrder() {
        let json = order.asJsonObject()
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            data.writeToURL(dataFileUrl(), atomically: true)
        } catch let error as NSError {
            print("saveOrder: error\(error)")
        }
    }
    
    private func loadOrder() {
        guard let data = NSData(contentsOfURL:dataFileUrl()) else {
            print("no data")
            return
        }
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                order = Order(today: NSDate(), withJsonObject: json)
            }
        } catch let error as NSError {
            print("loadOrder: error\(error)")
        }
    }
    
    private func dataFileUrl() -> NSURL {
        let fm = NSFileManager()
        let url: NSURL?
        do {
            url = try fm.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
        } catch let error as NSError {
            print("dataFileUrl: error\(error)")
            url = nil
        }
        return NSURL(string: "orders.json", relativeToURL: url)!
    }
    
    private func updateSendButtonLabel() {
        let label: String
        if (order.alreadyOrdered) {
            label = "Rückgängig"
        } else {
            label = "Abschicken"
        }
        sendButton.setTitle(label, forState: UIControlState.Normal)
    }
    
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send email, sorry!")
            return
        }
        let mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(["example@example.com"])
        mailer.setSubject("Essen \(order.weekLabel(1))")
        let body = "Hallo Schatz,\n\nich habe nächste Woche \(order.orderedDays()) bestellt.\n\nciao\nMartina\n💕"
        mailer.setMessageBody(body, isHTML: false)
        presentViewController(mailer, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

