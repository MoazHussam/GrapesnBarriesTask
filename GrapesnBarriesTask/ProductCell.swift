//
//  ProductCell.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/11/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import UIKit

class ProductCell {
    
    let product: Product
    
    init(product: Product) {
        self.product = product
        
        var imageData: Data?
        DispatchQueue.global(qos: .userInteractive).async {
            imageData = try? Data(contentsOf: URL(string: product.image.url)! )
        }
            }
    
    
    
}
