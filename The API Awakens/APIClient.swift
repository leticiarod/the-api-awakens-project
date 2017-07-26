//
//  APIClient.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/24/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation

class APIClient {
    let downloader = JSONDownloader()
    
    func searchForPeople(completion: @escaping ([People], APIError?) -> Void){
        let endpoint = Itunes.people(url: nil)
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            print(results)
            let people  = results.flatMap { People(json: $0) }
            print(people)
            completion(people,nil)
        }
    }
    
    func lookupCharacter(withUrl url: String, completion: @escaping (People?, APIError?) -> Void) {
        let endpoint = Itunes.people(url: url)
        
        performLookupRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
          /*  guard let artistInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain artist info."))
                return
            }
            
            guard let artist = Artist(json: artistInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse artist information."))
                return
            }
            */
           // let albumResults = results[1..<results.count]
            let people = People(json: results)
            print("1 persom \(people?.url)")
            
            completion(people, nil)
        }
        
    }

    func searchForStarships(completion: @escaping ([Starship], APIError?) -> Void){
        let endpoint = Itunes.starships(url: nil)
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            //print(results)
            let starship  = results.flatMap { Starship(json: $0) }
           // print(starship)
            completion(starship,nil)
        }
    }
    
    func lookupStarship(withUrl url: String, completion: @escaping (Starship?, APIError?) -> Void) {
        let endpoint = Itunes.starships(url: url)
        
        print("ENDPOINT \(endpoint.request)")
        performLookupRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
    
            print("result unico \(results)")
            
            let starship = Starship(json: results)
            
            completion(starship, nil)
        }
        
    }

    func searchForVehicles(completion: @escaping ([Vehicle], APIError?) -> Void){
        let endpoint = Itunes.vehicles(url: nil)
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            //print(results)
            let vehicle  = results.flatMap { Vehicle(json: $0) }
            //print(vehicle)
            completion(vehicle,nil)
        }
    }
    
    func lookupVehicle(withUrl url: String, completion: @escaping (Vehicle?, APIError?) -> Void) {
        let endpoint = Itunes.vehicles(url: url)
        
        print("ENDPOINT \(endpoint.request)")
        performLookupRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            
            print("result unico \(results)")
            
            let vehicle = Vehicle(json: results)
            
            completion(vehicle, nil)
        }
        
    }
    

    
    typealias Results = [[String: Any]]
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, APIError?) -> Void) {
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonParsingFailure(message: "JSON data does not contain reuslts"))
                    return
                }
                
                
                completion(results, nil)
            }
        }
        
        task.resume()
    }
    
    private func performLookupRequest(with endpoint: Endpoint, completion: @escaping ([String: Any]?, APIError?) -> Void) {
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                
                completion(json, nil)
            }
        }
        
        task.resume()
    }
}
