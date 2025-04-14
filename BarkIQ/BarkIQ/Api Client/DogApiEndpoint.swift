//
//  DogApiEndpoint.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation

enum DogApiEndpoint {
    case breeds
    case randomImage(_ breed: Breed)
    
    private var baseURL: String {
        "https://dog.ceo/api"
    }
    
    private var relativePath: String {
        switch self {
        case .breeds:
            return "/breeds/list/all"
        case .randomImage(let breed):
            if let subType = breed.subType {
                return "/breed/\(breed.name)/\(subType)/images/random"
            }
            
            return "/breed/\(breed.name)/images/random"
        }
    }
    
    var url: URL? {
        URL(string: baseURL + relativePath)
    }
}
