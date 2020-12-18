//
//  CacheManager.swift
//  PixbayApp
//
//  Created by D2k on 18/12/20.
//

import Foundation

import Foundation

/// To cache Search Results
class CacheManager {
    // MARK: Properties
    private let cache = NSCache<NSString, NSString>()
    private var keys = [NSString]()
    
    static let shared = CacheManager()
    
    // MARK: Init Methods
    private init() {
        cache.countLimit = 5
    }
    
    // MARK: Methods
    func insert(searchText: String) {
        let key = searchText as NSString
        
        if keys.contains(key) {
            return
        }
        
        if keys.count == 10 {
            if let first = keys.first {
                remove(searchText: first)
            }
            
        }
        
        cache.setObject(key, forKey: key)
        keys.append(key)
    }
    
    func get(searchText: NSString) -> NSString? {
        if let searchText = cache.object(forKey: searchText) {
            print("The object is still cached")
            return searchText
        } else {
            print("Web image went away")
            return nil
        }
    }
    
    func fetchRecentSearches() -> [String]? {
        var searches: [String] = []
        guard !keys.isEmpty else {
            return nil
        }
        for key in keys.reversed() {
            if let searchText = get(searchText: key) {
                searches.append(searchText as String)
            }
        }
        return searches
    }
    
    func remove(searchText: NSString) {
        if let index = keys.firstIndex(of: searchText) {
            keys.remove(at: index)
        }
        cache.removeObject(forKey: searchText)
    }
}
