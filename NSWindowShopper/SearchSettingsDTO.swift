//
//  SearchSettingsDTO.swift
//  NSWindowShopper
//
//  Created by Shawn Namdar on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

enum SortType : Int{
    case Distance = 0
    case Price = 1
    case Newest = 2
}

enum SortOrder : Int{
    case Ascending = 0
    case Descending = 1
}

class SearchSettingsDTO {
    
    var keyphrase : String?
    
    var availableCategories : [Category]?
    var selectedCategory : Category?
    
    var sortType : SortType?
    var sortOrder : SortOrder?
    
    var distanceInMiles : Int? = 30
}