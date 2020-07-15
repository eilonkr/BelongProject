//
//  CountryManager.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import UIKit
import SVGKit

struct CountryManager {
    enum ManagerError: Error {
        case invalidURL
        case invalidSVG
    }
    
    fileprivate static let invalidSVGs = [
        "https://restcountries.eu/data/shn.svg"
    ]
    
    private static let urlString = "https://restcountries.eu/rest/v2/all"
    
    private static let cache = CacheService<UIImage>()
    
    typealias CountryHandler = (Result<[Country], Error>) -> Void

    static func fetchCountries(_ handler: @escaping CountryHandler) {
        guard let url = URL(string: urlString) else {
            handler(.failure(ManagerError.invalidURL))
            return
        }
        
        NetworkService<[Country]>.get(fromURL: url) { result in
            switch result {
                case .success(let countries):
                    handler(.success(countries))
                case .failure(let error):
                    handler(.failure(error))
            }
        }
    }
    
    /// Throws if the country's image URL is invalid
    static func flagImage(forCountry country: Country, index: Int, handler: @escaping (UIImage?, Int) -> Void) throws {
        guard let url = URL(string: country.flagURL ?? "") else { throw ManagerError.invalidURL }
        if invalidSVGs.contains(url.absoluteString) { throw ManagerError.invalidSVG }
        if let image = cache.get(forKey: url.absoluteString) {
            handler(image, index)
            return
        }
        
        DispatchQueue.global().async {
            guard
                let data = try? Data(contentsOf: url),
                let image = SVGKImage(data: data)
            else {
                DispatchQueue.main.async {
                    handler(.none, index)
                }
                
                return
            }
            
            // We are resizing the image in order to preserve memory
            guard let flagImage = image.uiImage.resizeFor(width: 100.0) else { handler(.none, index); return }
            cache.set(flagImage, forKey: url.absoluteString)
            DispatchQueue.main.async {
                handler(flagImage, index)
            }
        }
    }
    
}
