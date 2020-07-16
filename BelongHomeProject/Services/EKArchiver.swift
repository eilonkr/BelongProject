//
//  Archiver.swift
//  BelongHomeOriject
//
//  Created by Eilon Krauthammer on 23/01/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

/// A service I wrote for saving data locally to the device's documents directory.
struct EKArchiver {
    enum Directory: String, CaseIterable {
        /// Variable.
        case countries
        
        fileprivate var directoryURL: URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(rawValue)
        }
    }
    
    private let directory: Directory
    
    public init(_ directory: Directory) {
        self.directory = directory
    }
    
    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.directoryURL.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: Encodable>(_ item: T, forKey key: String, inSubdirectory subdir: String? = nil) throws {
        if !FileManager.default.fileExists(atPath: directory.directoryURL.appendingPathComponent(subdir ?? directory.rawValue).path) {
            // Directory doesn't exist.
            try createDirectory(extension: subdir ?? directory.rawValue)
        }
        
        let data = try JSONEncoder().encode(item)
        let path = self.directory.directoryURL.appendingPathComponent(subdir ?? directory.rawValue).appendingPathComponent(fn(key))
        try data.write(to: path)
    }
    

    public func get<T: Decodable>(itemForKey key: String, ofType _: T.Type) -> T? {
        let path = self.directory.directoryURL.appendingPathComponent(fn(key))
        guard
            let data = try? Data(contentsOf: path),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else { return .none }
        return object
    }
    
    public func all<T: Decodable>(_: T.Type, pathExtension: String? = nil) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: directory.directoryURL.appendingPathComponent(pathExtension ?? directory.rawValue), includingPropertiesForKeys: nil, options: [])
        
        var entries = [T]()
        for file in contents {
            let data = try Data(contentsOf: file)
            let object = try JSONDecoder().decode(T.self, from: data)
            entries.append(object)
        }
        
        return entries
        
//        return try contents.compactMap {
//            let data = try Data(contentsOf: $0)
//            return try JSONDecoder().decode(T.self, from: data)
//        }
    }
    
    public func removeAll(extension ext: String? = nil) throws {
        let url = directory.directoryURL.appendingPathComponent(ext ?? directory.rawValue)
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory(extension ext: String? = nil) throws {
        try FileManager.default.createDirectory(atPath: directory.directoryURL.appendingPathComponent(ext ?? "").path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Clears all archives from all directories.
    static func clearAllCache() throws {
        for path in Self.Directory.allCases {
            try Self(path).removeAll()
        }
    }
    
}
