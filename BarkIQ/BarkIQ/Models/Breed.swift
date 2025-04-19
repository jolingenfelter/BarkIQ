//
//  Breed.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct Breed: Equatable, Hashable, CustomStringConvertible {
    let name: String
    let subType: String?
    
    init(
        name: String,
        subType: String? = nil
    ) {
        self.name = name
        self.subType = subType
    }
    
    var displayName: String {
        if let subType {
            return "\(subType.capitalized) \(name.capitalized)"
        }
        
        return name.capitalized
    }
    
    var description: String {
        """
        Breed {
            name: \(name),
            subType: \(subType ?? "nil"),
            displayName: \(displayName)
        }
        """
    }
    
    static let mock1 = Breed(
        name: "shepherd",
        subType: "australian"
    )
    
    static let mock2 = Breed(
        name: "hound",
        subType: "english"
    )
    
    static let mock3 = Breed(name: "pug")
    
    static let mock4 = Breed(name: "boxer")
    
    static let mockArray = [mock1, mock2, mock3, mock4]
}
