//
//  ProductsCollectionViewCell.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/11/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var imageLoadingSpinner: UIActivityIndicatorView! {
        didSet {
            imageLoadingSpinner.startAnimating()
        }
    }
        
    var product: Product? {
        didSet {
            if product != nil {
                updateUI()
            }
        }
    }
    
    func updateUI() {
        
        imageLoadingSpinner.startAnimating()
        productDescription.text = product?.productDescription
        price.text = "$\((product?.price)!)"
        if product?.image != nil {
            imageView.image = UIImage(data: product!.image!)
            imageLoadingSpinner.stopAnimating()
            
        }
    }
    
    func clearCache() {
        imageView.image = UIImage()
    }
    
    override func apply(_ layoutAttributes: (UICollectionViewLayoutAttributes!)) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? ProductsLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.imageHeight
        }
    }
    
}
