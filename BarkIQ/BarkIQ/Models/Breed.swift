//
//  Breed.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct Breed: CustomStringConvertible {
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
}
