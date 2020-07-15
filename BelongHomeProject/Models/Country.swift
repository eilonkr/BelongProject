//
//  Country.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

struct Country: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name, flagURL = "flag"
    }
    
    let name: String
    let flagURL: String?
    
}
