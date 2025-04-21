//
//  Untitled.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import Testing
@testable import BarkIQ

struct BreedsResponseParserTests {
    
    @Test func testMasterBreedWithoutSubBreeds() {
        let input: [String: [String]] = [
            "pug": []
        ]
        
        let result = BreedsResponseParser.parseBreeds(input)
        
        #expect(result.count == 1)
        #expect(result[0].name == "pug")
        #expect(result[0].subType == nil)
    }
    
    @Test func testMasterBreedWithSubBreeds() {
        let input: [String: [String]] = [
            "terrier": ["boston", "bull", "yorkshire"]
        ]
        
        let result = BreedsResponseParser.parseBreeds(input)
        
        #expect(result.count == 3)
        #expect(result.contains { $0.name == "terrier" && $0.subType == "boston" }, "Expected to find 'terrier' with subType 'boston'.")
        #expect(result.contains { $0.name == "terrier" && $0.subType == "bull" }, "Expected to find 'terrier' with subtype 'bull'.")
        #expect(result.contains { $0.name == "terrier" && $0.subType == "yorkshire" }, "Expected to find 'terrier' with subtype 'yorkshire'.")
    }
    
    @Test func testMixedBreeds() {
        let input: [String: [String]] = [
            "pug": [],
            "shepherd": ["australian", "german"]
        ]
        
        let result = BreedsResponseParser.parseBreeds(input)
        
        #expect(result.count == 3)
        #expect(result.contains { $0.name == "pug" && $0.subType == nil }, "Expected to find 'pug' without a subtype.")
        #expect(result.contains { $0.name == "shepherd" && $0.subType == "australian" }, "Expected to find 'shepherd' with subtype 'austrailian'." )
        #expect(result.contains { $0.name == "shepherd" && $0.subType == "german" }, "Expected to find 'shepherd' with subtype 'german'.")
    }
}
