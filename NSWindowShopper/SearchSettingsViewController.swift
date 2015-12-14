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

    static var searchSettingsDTO = SearchSettingsDTO()
    
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
        
        self.setValues(SearchSettingsViewController.searchSettingsDTO)
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(recognizer)

        self.searchTextField.delegate = self
    }
    
    func setValues(dto: SearchSettingsDTO) {
        self.searchTextField.text = dto.keyphrase
        if dto.selectedCategory == nil {
            self.currentCategoryButton.setTitle("All", forState: UIControlState.Normal)
        } else {
            self.currentCategoryButton.setTitle(dto.selectedCategory!.name, forState: UIControlState.Normal)
        }
        if dto.sortType == nil {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = 0
        } else {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = dto.sortType!.rawValue
        }
        if dto.sortOrder == nil {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = 0
        } else {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = dto.sortOrder!.rawValue
        }
        if dto.distanceInMiles == nil {
            self.distanceInMilesSlider.setValue(30, animated: true)
        } else {
            self.distanceInMilesSlider.setValue(Float(dto.distanceInMiles!), animated: true)
        }
    }
    
    func createDTOForViewDismissal (){
        let dto = SearchSettingsViewController.searchSettingsDTO
        dto.keyphrase = self.searchTextField.text
        dto.sortType = SortType(rawValue: self.sortTypeSegmentConrtrol.selectedSegmentIndex)
        dto.sortOrder = SortOrder(rawValue: self.sortTypeSegmentConrtrol.selectedSegmentIndex)
        dto.distanceInMiles = Int(self.distanceInMilesSlider.value)
    }
    
    func handleCancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleResetPressed() {
        self.setValues(SearchSettingsViewController.searchSettingsDTO)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func handleCurrentCategoryTapped() {
        performSegueWithIdentifier("filterToCategory", sender: nil)
    }
    
    @IBAction func handleSortTypeSegmentConrolValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.sortOrderSegmentControl.enabled = true
            UIView.animateWithDuration(0.3, animations: {
                self.sortOrderSegmentControl.alpha = 1
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.sortOrderSegmentControl.alpha = 0
            }, completion: { (_) -> Void in
                self.sortOrderSegmentControl.enabled = false
            })
        }
    }
    
    @IBAction func handleSortOrderSegmentConrolValueChanged(sender: UISegmentedControl) {
    }
    
    @IBAction func handleApplyButtonPressed(sender: UIButton) {
        self.createDTOForViewDismissal()
        self.navigationController?.popViewControllerAnimated(true)
    }
}