//
//  Breed.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct Breed: Identifiable, Equatable, Hashable, CustomStringConvertible {
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
    
    var id: String {
        if let subType {
            return "\(subType)-\(name)"
        }
        
        return name
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
    
    static let mock1 = Breed(name: "shepherd", subType: "australian")
    static let mock2 = Breed(name: "hound",subType: "english")
    static let mock3 = Breed(name: "pug")
    static let mock4 = Breed(name: "boxer")
    static let mock5 = Breed(name: "terrier", subType: "border")
    static let mock6 = Breed(name: "retriever", subType: "golden")
    static let mock7 = Breed(name: "bulldog", subType: "french")
    static let mock8 = Breed(name: "dachshund")
    static let mock9 = Breed(name: "beagle")
    static let mock10 = Breed(name: "chihuahua")
    static let mock11 = Breed(name: "husky", subType: "siberian")
    static let mock12 = Breed(name: "spaniel", subType: "cocker")
    
    static let mockArray = [
        mock1,
        mock2,
        mock3,
        mock4,
        mock5,
        mock6,
        mock7,
        mock8,
        mock9,
        mock10,
        mock11,
        mock12
    ]
}
