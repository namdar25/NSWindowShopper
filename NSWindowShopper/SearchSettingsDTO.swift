//
//  SearchSettingsDTO.swift
//  NSWindowShopper
//
//  Created by Shawn Namdar on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

enum SortType{
    case Price
    case Distance
}

enum SortOrder{
    case Ascending
    case Descending
}

enum CategoryType : String{
    case Blah = "Blah"
    case Bluh = "Bluh"
    case Bleh = "Bleh"
    case All = "All"
    
    var description : String {
        get {
            return self.rawValue
        }
    }
}

class SearchSettingsDTO {
    let categoryType = [CategoryType.Blah,CategoryType.Bluh,CategoryType.Bleh,CategoryType.All]
    var currentCategory : String? = "All"
    var sortType : SortType? = SortType.Price
    var sortOrder : SortOrder? = SortOrder.Ascending
    var priceMin : Double? = 0.0
    var priceMax : Double? = DBL_MAX
    var distanceInMiles : Int? = 30
}