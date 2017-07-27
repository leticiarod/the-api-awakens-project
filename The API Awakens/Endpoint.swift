//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/24/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        print(components)
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum Itunes {
    case people(url: String?, page: Int?)
    case starships(url: String?, page: Int?)
    case vehicles(url: String?, page: Int?)
    case planet(url: String)
}

extension Itunes: Endpoint {
    
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
            switch self {
            case .people(let url, let page):
                if let url = url {
                    print("URL \(url)")
                    var urlArray = url.components(separatedBy: "/")
                    print(" cuanto tiene el arr urlArray[5] \(urlArray[5])")
                    return "/api/people/\(urlArray[5])"
                }
                else{
                    
                    return "/api/people"
                }
                
                
            case .starships(let url, let page):
                if let url = url {
                    print("URL \(url)")
                    var urlArray = url.components(separatedBy: "/")
                    print(" cuanto tiene el arr urlArray[5] \(urlArray[5])")
                    return "/api/starships/\(urlArray[5])"
                }
                else{
                    return "/api/starships/"
                }
                
            case .vehicles(let url, let page):
                if let url = url {
                    print("URL \(url)")
                    var urlArray = url.components(separatedBy: "/")
                    print(" cuanto tiene el arr urlArray[5] \(urlArray[5])")
                    return "/api/vehicles/\(urlArray[5])"
                }
                else {
                    return "/api/vehicles/"
                }
            case .planet(let url):
                print("URL \(url)")
                var urlArray = url.components(separatedBy: "/")
                print(" cuanto tiene el arr urlArray[5] \(urlArray[5])")
                return "/api/planets/\(urlArray[5])"
           
        }

    }
    
    var queryItems: [URLQueryItem]{
        switch self {
        case .people(let url, let page): var result = [URLQueryItem]()
                                            if let page = page {
                                                let pageItem = URLQueryItem(name: "page", value: String(page))
                                                result.append(pageItem)

                                            }
                                         return result
        case .starships(let url, let page): var result = [URLQueryItem]()
                                            if let page = page {
                                                let pageItem = URLQueryItem(name: "page", value: String(page))
                                                result.append(pageItem)
            
                                            }
                                            return result
        case .vehicles(let url, let page): var result = [URLQueryItem]()
                                 if let page = page {
                                    let pageItem = URLQueryItem(name: "page", value: String(page))
                                    result.append(pageItem)
            
                                    } 
                                    return result
        default: fatalError()
        }
    }
}




