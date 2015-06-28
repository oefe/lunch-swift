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
        order = loadOrder() ?? order
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
        var cell = self.tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchTableViewCell
        
        cell.textLabel?.text = order.dayLabel(week: indexPath.section, day: indexPath.row)
        
        cell.toggle.on = order.valueForWeek(indexPath.section, day: indexPath.row)
        cell.toggle.enabled = indexPath.section > 0 && !order.alreadyOrdered
        cell.toggle.tag = indexPath.row
        
        return cell
    }
    
    @IBAction
    func valueChanged(sender: UISwitch) {
        println("Changing day \(sender.tag) to \(sender.on)")
        order.next[sender.tag] = sender.on
        saveOrder(order)
    }
    
    @IBAction
    func sendOrder(sender: UIButton) {
        if !order.alreadyOrdered {
            sendEmail()
        }
        order.alreadyOrdered = !order.alreadyOrdered
        saveOrder(order)
        tableView.reloadData()
        updateSendButtonLabel()
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
        if !MFMailComposeViewController.canSendMail() {
            println("Cannot send email, sorry!")
            return
        }
        let mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(["example@example.com"])
        mailer.setSubject("Essen \(order.weekLabel(0))")
        let body = "Hallo Schatz,\n\nich habe nächste Woche \(order.orderedDays()) bestellt.\n\nciao\nMartina\n💕"
        mailer.setMessageBody(body, isHTML: false)
        presentViewController(mailer, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

