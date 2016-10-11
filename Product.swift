//
//  Product.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/10/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

struct Product {
    
    let id:Int
    let description: String
    let price: Float
    let image: ProductImage
    
    struct ProductImage {
        let url: String
        let height: Int
        let width: Int
//        var imageData: Data?
//
//        init(url: String, height: Int, width: Int) {
//            
//            self.url = url
//            self.height = height
//            self.width = width
//            
//            self.imageData = try? Data(contentsOf: URL(string: url)!)
//            
//        }
    }
}
