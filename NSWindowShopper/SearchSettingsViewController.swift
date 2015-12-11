//
//  SearchSettingsViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class SearchSettingsViewController : UIViewController {
    
    override func viewDidLoad() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleCancelPressed"))
        let resetButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleResetPressed"))
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: false)
        self.navigationItem.setLeftBarButtonItem(resetButton, animated: false)
    }
    
    func handleCancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func handleResetPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}