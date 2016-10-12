//
//  Product.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/10/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

let imageDataHasFinishedDownloadingNotification = "com.moazahmeed.imageDataHasFinishedDownloadingNotification"

class Product {
    
    let id:Int
    let productDescription: String
    let price: Float
    var image: Data?
    var imageSize: (width: Int, height: Int)?
    var imageUrl: String? {
        didSet {
            getImage { (image) in

                self.image = image
                NotificationCenter.default.post(name: Notification.Name(rawValue: imageDataHasFinishedDownloadingNotification), object: self)
            }
        }
    }
    
    init(id: Int, description: String, price: Float) {
        self.id = id
        self.productDescription = description
        self.price = price
    }
    
    
    
//    convenience init(id: Int, description: String, price: Float, imageUrl: String, imageWidth: Int, imageHeight: Int) {
//        
//        self.init(id: id,description: description,price: price)
//        
//        self.imageUrl = imageUrl
//        self.imageSize = (imageWidth, imageHeight)
//    }
    
    
        func getImage(completionHandler: @escaping (Data?) -> Void) {
            
            DispatchQueue.global(qos: .userInteractive).async {
                let url = URL(string: self.imageUrl!)!
                let data = try? Data(contentsOf: url)
                
                if let imageData = data {
                    completionHandler(imageData)
                } else {
                    completionHandler(nil)
                }
                
            }

        }
    }

