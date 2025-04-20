//
//  BreedsResponseParser.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct BreedsResponseParser {
    /// A utility for converting the Dog CEO API's raw JSON response into a flat list of `Breed` values.
    ///
    /// The API returns a JSON object in the following structure:
    ///
    /// ```json
    /// {
    ///   "message": {
    ///     "retriever": ["golden", "labrador", "chesapeake"],
    ///     "pug": [],
    ///     "shepherd": ["australian"]
    ///   },
    ///   "status": "success"
    /// }
    /// ```
    ///
    /// The `message` field is a dictionary where:
    /// - Each **key** is a master breed name (e.g., `"retriever"`)
    /// - Each **value** is an array of sub-breeds (empty if there are none)
    ///
    /// This method flattens that structure into an array of `Breed` values:
    /// - If a breed has subtypes, one `Breed` is created for each combination of (name, subType)
    /// - If the breed has no subtypes, a single `Breed` is created with just the name
    ///
    /// - Parameter data: A dictionary of breed names and their sub-breeds, typically from the `message` field
    /// - Returns: A flat list of `Breed` instances ready for use in the app
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
    
        return breeds
    }
}
