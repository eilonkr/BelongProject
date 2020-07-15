//
//  LocalDatabaseManager.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

struct LocalDatabaseManager {
    
    private static let archiver = EKArchiver(.countries)
    
    static func addCountry(_ country: Country) throws {
        // Check if country already exists; Carry on saving if it doesn't.
        guard !(archiver.itemExists(forKey: country.name)) else { return }
        try archiver.put(country, forKey: country.name)
    }
    
    static func getLocalCountries() throws -> [Country] {
        return try archiver.all(Country.self) ?? []
    }
    
}
