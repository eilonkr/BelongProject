//
//  CacheService.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import UIKit

class CacheService {
    
    /// Singleton
    static let shared = CacheService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    public func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    public func set(_ object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
}
