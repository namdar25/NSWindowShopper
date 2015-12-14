//
//  CategoryProxy.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/11/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

protocol CategoryProxyDelegate : AnyObject {
    
    func loadedCategories(categories : [Category]?);
    func failedToLoadCategories();
    
}

class CategoryProxy {
    
    private weak var delegate : CategoryProxyDelegate?
    private var loadedCategories : [Category]?
    
    // MARK - Lifecycle
    
    init(delegate : CategoryProxyDelegate) {
        self.delegate = delegate;
    }
    
    // MARK - Network Interface
    
    func loadCategories() {
        let urlToLoad = NSURL(string: "https://\(self.urlToLoad())");
        if (urlToLoad == nil) {
            return;
        }
        
        let request = NSURLRequest(URL: urlToLoad!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error != nil || data == nil) {
                self.notifyDelegateOfFailure()
            } else {
                let parsedCategoryData : [Category]? = self.parseJsonData(data!);
                if (parsedCategoryData == nil) {
                    self.notifyDelegateOfFailure()
                } else {
                    self.loadedCategories = parsedCategoryData!
                    self.notifyDelegateOfLoadedCategories()
                }
            }
        }
        task.resume()
    }
    
    // MARK - Delegate Interface
    
    func notifyDelegateOfFailure() {
        if(self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate!.failedToLoadCategories()
            })
        }
    }
    
    func notifyDelegateOfLoadedCategories() {
        if(self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate!.loadedCategories(self.loadedCategories)
            })
        }
    }
    
    // Mark - JSON Parsing
    
    func parseJsonData(jsonData : NSData) -> [Category]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.AllowFragments)
            let dataJsonDictionary = json["data"] as! NSDictionary
            let categoriesJsonArray : [NSDictionary] = dataJsonDictionary["categories"] as! [NSDictionary];
            
            return self.parseCategories(categoriesJsonArray);
        } catch {
            return nil;
        }
    }
    
    func parseCategories(jsonArray: NSArray) -> [Category]? {
        var categoriesToReturn : [Category] = [];
        
        for categoryData in jsonArray {
            let categoryDictionary = categoryData as! NSDictionary;
            let newCategory = categoryForCategoryDictionary(categoryDictionary);
            categoriesToReturn.append(newCategory);
        }
        
        return categoriesToReturn;
    }
    
    func categoryForCategoryDictionary(categoryDictionary : NSDictionary) -> Category {
        let category = Category()
        category.id = categoryDictionary["id"] as? Int
        category.name = categoryDictionary["name"] as? String
        return category
    }
    
    // MARK - Source
    
    func urlToLoad() -> String {
        let sourceString : NSString = obfuscatedURLString();
        let modifiedString = NSMutableString();
        for var index = 0; index < sourceString.length; index++ {
            var character = (CChar(sourceString.characterAtIndex(index)) - CChar(1));
            let newString = NSString(bytes: &character, length: sizeofValue(character), encoding: NSUTF8StringEncoding)
            modifiedString.appendString(newString as! String)
        }
        return modifiedString as String;
    }
    
    func obfuscatedURLString() -> NSString {
        return "xxx/pggfsvq.tuh/dpn0bqj0w30dbufhpsjft0"
    }
}