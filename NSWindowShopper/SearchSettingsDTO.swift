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
    case Newest
    case Distance
}

enum SortOrder{
    case Ascending
    case Descending
}

class SearchSettingsDTO {
    
    var keyphrase : String?
    
    var availableCategories : [Category]?
    var selectedCategory : Category?
    
    var sortType : SortType?
    var sortOrder : SortOrder?
    
    var priceMin : Double?
    var priceMax : Double?
    
    var distanceInMiles : Int? = 30
}