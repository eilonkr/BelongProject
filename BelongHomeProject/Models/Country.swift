//
//  Country.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

struct Country: Codable, Equatable {
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
    
    enum CodingKeys: String, CodingKey {
        case name, population, flagURL = "flag"
    }
    
    let name: String
    let flagURL: String?
    private let population: Int
    
    public var populationString: String {
        return (population as NSNumber).description(withLocale: Locale.current)
    }
    
}
