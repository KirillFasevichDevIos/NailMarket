//
//  ImageCollectionViewCell.swift
//  ShopOnlineUdem
//
//  Created by admin on 04.07.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
    
}
