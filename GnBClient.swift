//
//  GnBClient.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/10/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation

class GnBClient {
    
    
    private func taskFromHTTPMethod(method: HTTPMethod, handler: @escaping HTTPResponseHandler) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: method.request, completionHandler: handler)
        
        return task
    }
    
    func performHTTPMethod(method: HTTPMethod, completionHandler: @escaping HTTPResponseParsedHandler) {
        
        let responseHandler: HTTPResponseHandler = { (data, response, error) in
            
            func handleError(error: String) {
                print("Error in url: \(method.request.url!)")
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "performHTTPMethod", code: 1, userInfo: userInfo))
            }
            
            //if request failed handle it and exit
            if let error = self.hasErrors(response: response, error) {
                handleError(error: error)
                return
            }
            
            //else we have the data :)
            guard let parsedData = self.convertData(data: data!) else {
                handleError(error: "Could not parse raw Json into foundation object")
                return
            }
            
            completionHandler(parsedData, nil)
            
            
        }
        
        let task = taskFromHTTPMethod(method: method, handler: responseHandler)
        
        task.resume()
    }
    
    
    enum HTTPMethodType {
        case GET
        case POST
    }
    
    enum HTTPMethodName {
        case getProducts
        
        var path: String {
            get {
                switch self {
                case .getProducts:
                    return Constants.MethodsStrings.getProductsMethod
                }
            }
        }
    }
    
    struct HTTPMethod {
        
        let name: HTTPMethodName
        let parameters: [String: AnyObject]?
        let type: HTTPMethodType
        let httpBody: [String:AnyObject]?
        let httpHeaders: [String:String]?
        
        var url: URL {
            get {
                return GnBClient.sharedInstance().URLWithParameters(methodName: self.name.path, parameters: self.parameters)
            }
        }
        
        var request: URLRequest {
            get {
                var request = URLRequest(url: self.url)
                
                switch self.type {
                case .GET:
                    return request
                case .POST:
                    request.httpBody = dataFromJson()
                    request.allHTTPHeaderFields = self.httpHeaders
                    return request
                }
            }
        }
        
        private func dataFromJson() -> Data? {
            
            let httpBody = try? JSONSerialization.data(withJSONObject: self.httpBody, options: .prettyPrinted)
            
            return httpBody
        }
    }
    
    // MARK: Helper Methods
    
    //given RAW Json, return usable foundation object
    private func convertData(data: Data) -> AnyObject? {
        
        let convertedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        return convertedData as AnyObject
    }
    
    //checks for errors and handles it
    private func hasErrors(response: URLResponse?, _ error: Error?) -> String? {
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            let messege = "There was an error with your request: \(error)"
            return (messege)
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...300 ~= statusCode else {
            let messege = "Your request returned a status code other than 2xx!"
            return (messege)
        }
        
        return nil
    }

    
    // get url
    private func URLWithParameters(methodName: String, parameters: [String:AnyObject]?) -> URL {
        
        var components = URLComponents()
        components.scheme = GnBClient.Constants.ApiScheme
        components.host = GnBClient.Constants.ApiHost
        components.path = methodName
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }

        }
        return components.url!
    }
    
    
    
    // MARK: Type alaises
    
    typealias HTTPResponseHandler = (Data?, URLResponse?, Error?) -> Void
    typealias HTTPResponseParsedHandler = (AnyObject?, Error?) -> Void
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> GnBClient {
        struct Singleton {
            static let sharedInstance = GnBClient()
        }
        return Singleton.sharedInstance
    }
    
}
