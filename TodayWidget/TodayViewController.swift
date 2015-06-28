//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Martina Oefelein on 26.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet
    var label: UILabel!
    
    var order = Order(today: NSDate())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        order = loadOrder() ?? order
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        if (order.today >= 5) {
            label.text = "Wochenende"
        } else if order.current [order.today] {
            label.text = "Heute Kantine"
        } else {
            label.text = "Nix Kantine heute"
        }

        completionHandler(NCUpdateResult.NewData)
    }
    
}
