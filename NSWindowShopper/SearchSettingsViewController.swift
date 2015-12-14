//
//  SearchSettingsViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

protocol SearchSettingsDelegate : AnyObject {
    func loadItems()
}

class SearchSettingsViewController : UIViewController, UITextFieldDelegate {

    static var searchSettingsDTO = SearchSettingsDTO()
    
    weak var delegate : SearchSettingsDelegate?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCategoryButton: UIButton!
    @IBOutlet weak var sortTypeSegmentConrtrol: UISegmentedControl!
    @IBOutlet weak var sortOrderSegmentControl: UISegmentedControl!
    @IBOutlet weak var distanceInMilesSlider: UISlider!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var applyButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        setCategoryButtonTitle()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleCancelPressed"))
        let resetButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleResetPressed"))
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: false)
        self.navigationItem.setLeftBarButtonItem(resetButton, animated: false)
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(recognizer)
        
        self.setValues(SearchSettingsViewController.searchSettingsDTO)
        
        self.searchTextField.layer.borderWidth = 1
        self.searchTextField.layer.cornerRadius = 6.0
        self.searchTextField.layer.borderColor = UIColor(white: 0.85, alpha: 1).CGColor
        self.currentCategoryButton.layer.cornerRadius = 9.0
        self.applyButton.layer.cornerRadius = 9.0
        
        self.searchTextField.layer.shadowColor = UIColor.blackColor().CGColor
        self.searchTextField.layer.shadowOffset = CGSizeZero
        self.searchTextField.layer.shadowOpacity = 1
        self.searchTextField.layer.shadowRadius = 15
        
        self.sortTypeSegmentConrtrol.layer.shadowColor = UIColor.blackColor().CGColor
        self.sortTypeSegmentConrtrol.layer.shadowOffset = CGSizeZero
        self.sortTypeSegmentConrtrol.layer.shadowOpacity = 0.7
        self.sortTypeSegmentConrtrol.layer.shadowRadius = 6
        
        self.sortOrderSegmentControl.layer.shadowColor = UIColor.blackColor().CGColor
        self.sortOrderSegmentControl.layer.shadowOffset = CGSizeZero
        self.sortOrderSegmentControl.layer.shadowOpacity = 0.7
        self.sortOrderSegmentControl.layer.shadowRadius = 6
        
        
        
        self.searchTextField.delegate = self
        super.viewDidLoad()
    }
    
    func setValues(dto: SearchSettingsDTO) {
        self.searchTextField.text = dto.keyphrase
        setCategoryButtonTitle()
        if dto.sortType == nil {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = 0
        } else {
            self.sortTypeSegmentConrtrol.selectedSegmentIndex = dto.sortType!.rawValue
        }
        if dto.sortOrder == nil {
            self.sortOrderSegmentControl.selectedSegmentIndex = 0
        } else {
            self.sortOrderSegmentControl.selectedSegmentIndex = dto.sortOrder!.rawValue
        }
        if dto.distanceInMiles == nil {
            self.distanceInMilesSlider.setValue(30, animated: true)
        } else {
            self.distanceInMilesSlider.setValue(Float(dto.distanceInMiles!), animated: true)
        }
        showOrHideSortOrderSegmentControl()
    }
    
    func createDTOForViewDismissal (){
        let dto = SearchSettingsViewController.searchSettingsDTO
        dto.keyphrase = self.searchTextField.text
        dto.sortType = SortType(rawValue: self.sortTypeSegmentConrtrol.selectedSegmentIndex)
        dto.sortOrder = SortOrder(rawValue: self.sortOrderSegmentControl.selectedSegmentIndex)
        dto.distanceInMiles = Int(self.distanceInMilesSlider.value)
    }
    
    func handleCancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleResetPressed() {
        let availbleCategories = SearchSettingsViewController.searchSettingsDTO.availableCategories
        SearchSettingsViewController.searchSettingsDTO = SearchSettingsDTO()
        self.setValues(SearchSettingsViewController.searchSettingsDTO)
        SearchSettingsViewController.searchSettingsDTO.availableCategories = availbleCategories
        showOrHideSortOrderSegmentControl()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.searchTextField.resignFirstResponder()
    }
    
    func setCategoryButtonTitle() {
        if SearchSettingsViewController.searchSettingsDTO.selectedCategory == nil {
            self.currentCategoryButton.setTitle("All", forState: UIControlState.Normal)
        } else {
            self.currentCategoryButton.setTitle(SearchSettingsViewController.searchSettingsDTO.selectedCategory!.name, forState: UIControlState.Normal)
        }
    }
    
    func showOrHideSortOrderSegmentControl () {
        if sortTypeSegmentConrtrol.selectedSegmentIndex == 1 {
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
    
    @IBAction func handleCurrentCategoryTapped() {
        performSegueWithIdentifier("filterToCategory", sender: nil)
    }
    
    @IBAction func handleSortTypeSegmentConrolValueChanged(sender: UISegmentedControl) {
        showOrHideSortOrderSegmentControl()
    }
    
    @IBAction func handleSortOrderSegmentConrolValueChanged(sender: UISegmentedControl) {
    }
    
    @IBAction func handleApplyButtonPressed(sender: UIButton) {
        self.createDTOForViewDismissal()
        if self.delegate != nil {
            self.delegate!.loadItems()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}