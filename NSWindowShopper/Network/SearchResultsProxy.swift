//
//  NetworkService.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/3/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import CoreLocation

protocol SearchResultsProxyDelegate : AnyObject {
    
    func loadedItems(items : [Item]);
    func failedToLoadItems();
    
}

class SearchResultsProxy {
    
    private weak var delegate : SearchResultsProxyDelegate?
    private var loadedItems : [Item]?
    private var pageNumber : Int = 1
    private var lastSearchSettingsDTO : SearchSettingsDTO?
    
    // MARK - Lifecycle
    
    init(delegate: SearchResultsProxyDelegate) {
        self.delegate = delegate;
    }
    
    // MARK - Network Interface
    
    func loadItemsWithSearchSettingsDTO(searchSettingsDTO : SearchSettingsDTO?) {
        self.loadedItems = nil
        self.lastSearchSettingsDTO = searchSettingsDTO;
        
        let mutableString = NSMutableString(format: "%@", "https://\(self.urlToLoad())/?page=\(self.pageNumber)");
        if (self.lastSearchSettingsDTO != nil) {
            self.appendKeyphraseParameterToString(mutableString)
            self.appendCategoryParameterToString(mutableString)
            self.appendSortParameterToString(mutableString)
            self.appendDistanceRadiusToString(mutableString)
        }

        let urlToLoad = NSURL(string: mutableString as String);
        if (urlToLoad == nil) {
            return;
        }
        
        self.loadItemsWithURL(urlToLoad!)
    }
    
    func loadNextPage() {
        self.pageNumber++
        self.loadItemsWithSearchSettingsDTO(self.lastSearchSettingsDTO)
    }
    
    func reloadItems() {
        self.loadedItems = nil
        self.pageNumber = 1
        self.loadItemsWithSearchSettingsDTO(self.lastSearchSettingsDTO)
    }
    
    // MARK - Sort/Filter Configuration
    
    private func appendKeyphraseParameterToString(mutableString : NSMutableString) {
        if (self.lastSearchSettingsDTO?.keyphrase == nil) {
            return;
        }
        
        mutableString.appendFormat("%@", "&q=\((self.lastSearchSettingsDTO?.keyphrase)!)");
    }
    
    private func appendCategoryParameterToString(mutableString : NSMutableString) {
        if (self.lastSearchSettingsDTO?.selectedCategory == nil) {
            return;
        }
        
        let id : Int = (self.lastSearchSettingsDTO?.selectedCategory!.id)!;
        mutableString.appendFormat("%@", "&cid=\(id)");
    }
    
    private func appendSortParameterToString(mutableString : NSMutableString) {
        if (self.lastSearchSettingsDTO?.sortType != nil) {
            switch (self.lastSearchSettingsDTO?.sortType)! {
            case SortType.Price:
                self.appendPriceSortParameterToString(mutableString);
                break;
            case SortType.Distance:
                mutableString.appendFormat("%@", "&sort=distance");
                break;
            case SortType.Newest:
                mutableString.appendFormat("%@", "&sort=-posted");
                break;
            }
        }
    }
    
    private func appendPriceSortParameterToString(mutableString : NSMutableString) {
        if (self.lastSearchSettingsDTO?.sortOrder != nil) {
            var orderString = ""
            if (self.lastSearchSettingsDTO?.sortOrder == SortOrder.Descending) {
                orderString = "-"
            }
            
            mutableString.appendFormat("&sort=%@price", orderString)
        }
    }
    
    private func appendDistanceRadiusToString(mutableString : NSMutableString) {
        if (self.lastSearchSettingsDTO?.distanceInMiles == nil) {
            return;
        }
        let roundedDistance = ((self.lastSearchSettingsDTO?.distanceInMiles)!/10)*10
        mutableString.appendFormat("%@", "&radius=\(roundedDistance)")
    }
    
    // MARK - Delegate Interface
    
    private func notifyDelegateOfFailure() {
        if(self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate!.failedToLoadItems();
            })
        }
    }
    
    private func notifyDelegateOfLoadedItems() {
        if(self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate!.loadedItems(self.loadedItems!);
            })
        }
    }
    
    // MARK - Private Networking
    
    private func loadItemsWithURL(urlToLoad : NSURL) {
        let request = NSURLRequest(URL: urlToLoad, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error != nil || data == nil) {
                self.notifyDelegateOfFailure();
            } else {
                let parsedItemData : [Item]? = self.parseJsonData(data!);
                if (parsedItemData == nil) {
                    self.notifyDelegateOfFailure();
                } else {
                    if (self.loadedItems == nil) {
                        self.loadedItems = parsedItemData!;
                    } else {
                        self.loadedItems!.appendContentsOf(parsedItemData!);
                    }
                    self.notifyDelegateOfLoadedItems();
                }
            }
        }
        task.resume();
    }
    
    // MARK - JSON Parsing
    
    private func parseJsonData(jsonData : NSData) -> [Item]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.AllowFragments)
            
            if (json["data"] == nil) {
                return nil
            }
            let dataJsonDictionary = json["data"] as! NSDictionary
            
            if (dataJsonDictionary["items"] == nil) {
                return nil;
            }
            let itemsJsonArray : [NSDictionary] = dataJsonDictionary["items"] as! [NSDictionary];
            
            return self.parseItems(itemsJsonArray);
        } catch {
            return nil;
        }
    }
    
    private func parseItems(jsonArray: NSArray) -> [Item]? {
        var itemsToReturn : [Item] = [];
        
        for itemData in jsonArray {
            let itemDictionary = itemData as! NSDictionary;
            let newItem = itemForItemDictionary(itemDictionary);
            itemsToReturn.append(newItem);
        }
        
        return itemsToReturn;
    }
    
    private func itemForItemDictionary(itemDictionary : NSDictionary) -> Item {
        let item = Item();
        item.name = itemDictionary["title"] as! String?;
        item.description = itemDictionary["description"] as! String?;
        item.imageURL = itemDictionary["get_img_permalink_small"] as! String?;
        item.hdImageURL = itemDictionary["get_img_permalink_large"] as! String?;
        item.price = numberForString(itemDictionary["price"] as! String)
        
        item.datePosted = dateForString(itemDictionary["post_date"] as! String);
        
        let itemLongitude = numberForString(itemDictionary["longitude"] as! String).doubleValue;
        let itemLatitude = numberForString(itemDictionary["latitude"] as! String).doubleValue;
        item.location = CLLocation(latitude: itemLongitude, longitude: itemLatitude);
        item.locationName = itemDictionary["location_name"] as! String?
        
        let ownerDictionary = itemDictionary["owner"] as! NSDictionary;
        item.profile = profileForOwnerDictionary(ownerDictionary);
        
        return item;
    }
    
    private func profileForOwnerDictionary(ownerDictionary: NSDictionary) -> Profile {
        let profile = Profile();

        profile.displayName = ownerDictionary["first_name"] as! String?;
        profile.dateJoined = dateForString(ownerDictionary["date_joined"] as! String);
        
        let profileDictionary = ownerDictionary["get_profile"] as! NSDictionary;
        profile.avatarURL = ownerDictionary["get_profile"]!["avatar_normal"] as! String?;

        let ratingDictionary = profileDictionary["rating"] as! NSDictionary;
        profile.ratingCount = (ratingDictionary["count"] as! NSNumber).integerValue;
        profile.ratingScore = ratingScoreForRatingDictionary(ratingDictionary);
        
        return profile;
    }
    
    private func ratingScoreForRatingDictionary(ratingDictionary : NSDictionary) -> NSNumber {
        let ratingAverage = ratingDictionary["average"];
        if (ratingAverage == nil || ratingAverage!.isKindOfClass(NSNull)){
            return 0
        } else {
            if (ratingAverage!.isKindOfClass(NSNumber)) {
                return ratingAverage as! NSNumber;
            }
            
            let ratingAverageString = ratingAverage as! String;
            return numberForString(ratingAverageString)
        }
    }
    
    // MARK - Helper
    
    private func numberForString(string : String) -> NSNumber {
        let numberFormatter = NSNumberFormatter();
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
        return numberFormatter.numberFromString(string)!
    }
    
    private func dateForString(string : String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        return dateFormatter.dateFromString(string)!
    }

    // MARK - Source
    private func urlToLoad() -> String {
        let sourceString : NSString = obfuscatedURLString();
        let modifiedString = NSMutableString();
        for var index = 0; index < sourceString.length; index++ {
            var character = (CChar(sourceString.characterAtIndex(index)) - CChar(1));
            let newString = NSString(bytes: &character, length: sizeofValue(character), encoding: NSUTF8StringEncoding)
            modifiedString.appendString(newString as! String)
        }
        return modifiedString as String;
    }
    
    private func obfuscatedURLString() -> NSString {
        return "bqj/pggfsvq.tuh/dpn0bqj0w30jufnt"
    }
    
}