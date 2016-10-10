//
//  GnBConstants.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/10/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation

extension GnBClient {
    
    
    struct Constants {
        
        // MARK: URL Constants
        static let ApiScheme = "http"
        static let ApiHost = "grapesnberries.getsandbox.com"
        
        // MARK: Method Names
        struct MethodsStrings {
            static let getProductsMethod = "/products"
        }

        
    }
    
    struct ParameterKeys {
        static let count = "count"
        static let fromID = "from"
    }
    
    struct JSONResponseKeys {
        static let id = "id"
        static let price = "price"
        static let image = "image"
        static let productDescription = "productDescription"
        static let imageHeight = "height"
        static let imageUrl = "url"
        static let imageWidth = "width"
    }
    
}
