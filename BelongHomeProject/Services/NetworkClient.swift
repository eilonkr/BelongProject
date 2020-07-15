//
//  NetworkClient.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation 

struct NetworkService<T: Decodable> {
    
    typealias ResultHandler = Result<T, Error>
    
    /// Fetch a decodable object from a given URL.
    static func get(fromURL url: URL, completion: @escaping (ResultHandler) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let _ = response, let data = data else { return }
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch let e {
                    completion(.failure(e))
                }
            }
            
        }.resume()
    }
}
