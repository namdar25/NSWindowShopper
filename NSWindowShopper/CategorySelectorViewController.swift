//
//  CategorySelectorController.swift
//  NSWindowShopper
//
//  Created by Shawn Namdar on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectorViewController : UIViewController {

    var lastSelectedIndex = 0
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (SearchSettingsViewController.searchSettingsDTO.availableCategories != nil) {
            return SearchSettingsViewController.searchSettingsDTO.availableCategories!.count
        }
        return 0
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return SearchSettingsViewController.searchSettingsDTO.availableCategories![row].name
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lastSelectedIndex = row
    }

    @IBAction func handleSelectCategoryButtonPushed(sender: UIButton) {
        let dto = SearchSettingsViewController.searchSettingsDTO
        dto.selectedCategory = dto.availableCategories![lastSelectedIndex]
        self.navigationController?.popViewControllerAnimated(true)
    }
}