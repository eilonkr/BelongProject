//
//  CacheService.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

struct CacheService<Object: AnyObject> {
    
    private let cache = NSCache<NSString, Object>()
    
    public func get(forKey key: String) -> Object? {
        cache.object(forKey: key as NSString)
    }
    
    public func set(_ object: Object, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
}
