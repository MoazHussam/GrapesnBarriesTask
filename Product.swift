//
//  Product.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/10/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

let imageDataDidFinishedDownloadingNotification = "com.moazahmeed.imageDataDidFinishedDownloadingNotification"

class Product {
    
    let id:Int
    let productDescription: String
    let price: Float
    var image: Data?
    var imageSize: (width: Int, height: Int)?
    var imageUrl: String? {
        didSet {
            getImage(forProduct: self) { (image) in

                //self.image = image
                NotificationCenter.default.post(name: Notification.Name(rawValue: imageDataDidFinishedDownloadingNotification), object: self)
            }
        }
    }
    
    init(id: Int, description: String, price: Float) {
        self.id = id
        self.productDescription = description
        self.price = price
    }
    
    func getImage(forProduct product: Product, completionHandler: @escaping (Data?) -> Void) {
            
        if product.image != nil { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let url = URL(string: self.imageUrl!)!
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                product.image = imageData
                completionHandler(imageData)
            } else {
                print("Failed to fetch image id \(product.id), attempting again")
                self.getImage(forProduct: product, completionHandler: completionHandler)
                return
            }
            
        }
        
    }
}

extension Product {
    
    func heightForDescription(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: productDescription).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
