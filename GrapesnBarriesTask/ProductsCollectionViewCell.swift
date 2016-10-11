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
    @IBOutlet weak var price: UILabel!
    
    
    var product: Product? {
        didSet {
            if product != nil {
                updateUI()
            }
        }
    }
    
    func updateUI() {
        
        productDescription.text = product?.description
        price.text = "$\((product?.price)!)"
        
        DispatchQueue.global(qos: .userInteractive).async {
            let url = URL(string: self.product!.image.url)!
            let data = try? Data(contentsOf: url)
          
            if let imageData = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
            
        }

    }
}
