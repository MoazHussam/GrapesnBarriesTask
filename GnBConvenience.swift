//
//  GnBConvenience.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/11/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation

extension GnBClient {
    
    func getProducts(fromID: Int, count: Int, products: @escaping ([Product]?) -> Void) {
        
        let parameters: [String:AnyObject] = [ParameterKeys.count:count as AnyObject,
                          ParameterKeys.fromID: fromID as AnyObject]
        
        let method = HTTPMethod(name: HTTPMethodName.getProducts, parameters: parameters, type: .GET, httpBody: nil, httpHeaders: nil)
        
        performHTTPMethod(method: method) { (data, error) in
            
            
            func handleError() {
                print("Could not parse Json object dictionary")
                
                products(nil)
            }
            
            guard error == nil else {
                handleError()
                return
            }
            
            guard let productsArray = data as? [[String:AnyObject]] else {
                handleError()
                return
            }
            
            var resultProducts = [Product]()
            
            for product in productsArray {
                guard let id = product[JSONResponseKeys.id] as? Int else {
                    handleError()
                    return
                }
                
                guard let description = product[JSONResponseKeys.productDescription] as? String else {
                    handleError()
                    return
                }
                
                guard let price = product[JSONResponseKeys.price] as? Float else {
                    handleError()
                    return
                }
                
                guard let imageDictionary = product[JSONResponseKeys.image] as? [String:AnyObject] else {
                    handleError()
                    return
                }
                
                guard let imageHeight = imageDictionary[JSONResponseKeys.imageHeight] as? Int else {
                    handleError()
                    return
                }
                
                guard let imageWidth = imageDictionary[JSONResponseKeys.imageWidth] as? Int else {
                    handleError()
                    return            }
                
                guard let imageUrl = imageDictionary[JSONResponseKeys.imageUrl] as? String else {
                    handleError()
                    return
                }
                
                let product = Product(id: id, description: description, price: price)
                product.imageUrl = imageUrl
                product.imageSize = (imageWidth, imageHeight)
                resultProducts.append(product)

            }
            
            products(resultProducts)
        }
        
    }
    
    
    
    
}
