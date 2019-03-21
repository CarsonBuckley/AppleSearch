//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Carson Buckley on 3/21/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import UIKit

class AppStoreItemController {
    
    //Base URL
    static let baseUrl = URL(string: "https://itunes.apple.com")
    
    static func fetchItemsOf(type: AppStoreItem.ItemType, searchTerm: String, completion: @escaping ([AppStoreItem]?) -> Void) {
        //1. Construct the URL/URLRequest
        guard let baseUrl = baseUrl?.appendingPathComponent("search"),
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { completion(nil) ; return }
        let querySearchTermItem = URLQueryItem(name: "term", value: searchTerm)
        let queryItemType = URLQueryItem(name: "entity", value: type.rawValue)
        components.queryItems = [querySearchTermItem, queryItemType]
        guard let finalUrl = components.url else { completion(nil) ; return }
        
        //2. Call our DataTask (decode ; .resume())
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            if let error = error {
                print("❌ \(error.localizedDescription) \(error) function: \(#function) ❌")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            do {
                guard let outerMostDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                    let resultsArray = outerMostDictionary["results"] as? [[String: Any]] else { completion(nil) ; return }
                
                let appStoreItems = resultsArray.compactMap{ AppStoreItem(itemType: type, dictionary: $0)}
                completion(appStoreItems)
                
            } catch {
                print("❌ \(error.localizedDescription) \(error) function: \(#function) ❌")
                completion(nil)
                return
            }
            }.resume()
    }
    
    static func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        //1. Construct the URL/URLRequest
        guard let url = URL(string: urlString) else { completion(nil) ; return }
        
        //2. Call the DataTask (.resume())
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
