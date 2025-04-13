//
//  BreedsResponseParser.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct BreedsResponseParser {
    static func parseBreeds(_ data: Dictionary<String, [String]>) -> [Breed] {
        var breeds: [Breed] = []
        for (name, subTypes) in data {
    
            if !subTypes.isEmpty {
                for subType in subTypes {
                    let breed = Breed(name: name, subType: subType)
                    breeds.append(breed)
                }
            } else {
                let breed = Breed(name: name)
                breeds.append(breed)
            }
        }
        
        print(breeds)
    
        return breeds
    }
}
