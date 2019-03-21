//
//  AppStoreItemTableViewCell.swift
//  AppleSearch
//
//  Created by Carson Buckley on 3/21/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import UIKit

class AppStoreItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appStoreArtworkImageView: UIImageView!
    
    //Landing Pad
    var appStoreItem: AppStoreItem? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let appStoreItem = appStoreItem else { return }
        nameLabel.text = appStoreItem.name
        descriptionLabel.text = appStoreItem.description
        fetchAndSetImageView()
        
    }
    
    func fetchAndSetImageView() {
        guard let imagePath = appStoreItem?.imagePath else { return }
        AppStoreItemController.fetchImage(urlString: imagePath) { (image) in
            DispatchQueue.main.async {
                
                self.appStoreArtworkImageView.image = image
            }
            
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        appStoreArtworkImageView.image = nil
    }
    
}
