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
            getImage(forProduct: self) { 
                NotificationCenter.default.post(name: Notification.Name(rawValue: imageDataDidFinishedDownloadingNotification), object: self)
            }
        }
    }
    
    init(id: Int, description: String, price: Float) {
        self.id = id
        self.productDescription = description
        self.price = price
    }
    
    private func getImage(forProduct product: Product, completionHandler: @escaping ()-> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let url = URL(string: product.imageUrl!)!
            product.image = Product.getImageContent(url: url, forID: product.id)
            completionHandler()
        }
        
    }
    
    private static func getImageContent(url: URL, forID id: Int) -> Data {
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            return imageData
        } else {
            print("Failed to fetch image id \(id), attempting again")
            return getImageContent(url: url, forID: id)
        }
        
    }
}

extension Product {
    
    func heightForDescription(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: productDescription).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
