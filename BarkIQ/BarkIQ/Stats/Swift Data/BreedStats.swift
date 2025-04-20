//
//  BreedStats.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import SwiftData

@Model
final class BreedStats {
    var name: String
    var subType: String?
    var displayName: String
    var streak: Int
    var streakHistory: [[Date]]
    var answerHistory: [Date: Bool]
    
    convenience init(
        breed: Breed,
        streak: Int = 0,
        streakHistory: [[Date]] = [],
        answerHistory: [Date : Bool] = [:]
    ) {
        self.init(
            name: breed.name,
            subType: breed.subType,
            displayName: breed.displayName,
            streak: streak,
            streakHistory: streakHistory,
            answerHistory: answerHistory
        )
    }
    
    init(
        name: String,
        subType: String? = nil,
        displayName: String,
        streak: Int,
        streakHistory: [[Date]],
        answerHistory: [Date : Bool]
    ) {
        self.name = name
        self.subType = subType
        self.displayName = displayName
        self.streak = streak
        self.streakHistory = streakHistory
        self.answerHistory = answerHistory
    }
}


