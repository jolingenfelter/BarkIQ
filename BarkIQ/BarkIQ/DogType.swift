//
//  DogType.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//


struct DogType: CustomStringConvertible {
    var breed: String
    var subBreed: String?
    
    var displayName: String {
        if let subBreed {
            return "\(breed) \(subBreed)"
        }
        
        return breed
    }
    
    var description: String {
        """
        DogType {
            breed: \(breed),
            subBreed: \(subBreed ?? "nil")
        }
        """
    }
}