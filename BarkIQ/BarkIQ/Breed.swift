//
//  Breed.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct Breed: CustomStringConvertible {
    var name: String
    var subBreeds: [String]
    
    var description: String {
        """
        Breed {
            name: \(name),
            subBreeds: \(subBreeds)
        }
        """
    }
}
