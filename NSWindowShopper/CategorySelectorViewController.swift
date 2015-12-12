//
//  CategorySelectorController.swift
//  NSWindowShopper
//
//  Created by Shawn Namdar on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectorViewController : UIViewController{

    var searchSettingsDTO : SearchSettingsDTO? = nil
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return searchSettingsDTO!.categoryType.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return searchSettingsDTO!.categoryType[row].description
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    
    }

    @IBAction func handleSelectCategoryButtonPushed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
    }
}