//
//  SearchSettingsViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class SearchSettingsViewController : UIViewController, UITextFieldDelegate {

    let searchSettingsDTO = SearchSettingsDTO()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCategoryButton: UIButton!
    @IBOutlet weak var sortTypeSegmentConrtrol: UISegmentedControl!
    @IBOutlet weak var sortOrderSegmentControl: UISegmentedControl!
    @IBOutlet weak var distanceInMilesSlider: UISlider!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleCancelPressed"))
        let resetButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleResetPressed"))
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: false)
        self.navigationItem.setLeftBarButtonItem(resetButton, animated: false)
        
        setDefaultValues()
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(recognizer)

        searchTextField.delegate = self
    }
    
    func setDefaultValues() {
        currentCategoryButton.setTitle("All", forState: UIControlState.Normal)
        sortTypeSegmentConrtrol.selectedSegmentIndex = 0
        sortOrderSegmentControl.selectedSegmentIndex = 0
        distanceInMilesSlider.setValue(30, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let categorySelectorViewController = segue.destinationViewController as! CategorySelectorViewController
            categorySelectorViewController.searchSettingsDTO = self.searchSettingsDTO
        }
    func handleCancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleResetPressed() {
        setDefaultValues()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func handleCurrentCategoryTapped() {
        performSegueWithIdentifier("filterToCategory", sender: nil)
    }
    
    @IBAction func handleSortTypeSegmentConrolValueChanged(sender: UISegmentedControl) {
        
    }
    
    @IBAction func handleSortOrderSegmentConrolValueChanged(sender: UISegmentedControl) {
    }
    
    @IBAction func handleApplyButtonPressed(sender: UIButton) {
    
    }
}