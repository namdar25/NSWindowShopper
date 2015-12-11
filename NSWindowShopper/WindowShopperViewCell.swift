//
//  WindowShopperViewCell.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class WindowShopperViewCell : UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var mostRecentlyLoadedImageURL : String?
    var hasConfiguredStaticUI : Bool = false
    
    // MARK - UI Configuration
    
    func configureWithItem(item : Item) {
        self.firstTimeUISetupIfNeeded()
        
        self.loadItemImage(item.hdImageURL!)
        self.titleLabel.text = item.name;
        self.priceLabel.text = item.formattedPriceText()
    }
    
    private func firstTimeUISetupIfNeeded() {
        if (!hasConfiguredStaticUI) {
            self.contentView.layer.cornerRadius = 9.0;
            self.contentView.clipsToBounds = true;
            
            self.itemImageView.clipsToBounds = true;
            self.itemImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
//            self.layer.shadowColor = ColorProvider.darkBorderColor.CGColor
//            self.layer.shadowRadius = 5
//            self.layer.shadowOpacity = 0.5
//            self.layer.masksToBounds = false;
//            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            
            hasConfiguredStaticUI = true
        }
    }
    
    private func loadItemImage(imageURL : String) {
        self.mostRecentlyLoadedImageURL = imageURL
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(imageURL) { (loadedImage, loadedImageURL) -> Void in
            if (weakSelf != nil && weakSelf!.mostRecentlyLoadedImageURL == loadedImageURL) {
                weakSelf!.itemImageView.image = loadedImage
            }
        }
    }
    
    // MARK - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.image = nil;
    }
    
}