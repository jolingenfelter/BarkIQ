//
//  BreedStats.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import SwiftData

/// Stores quiz history and performance stats for a specific breed.
/// Tracks how often a breed has been answered correctly or incorrectly,
/// along with mistake history, and streaks.
@Model
final class BreedStats {
    var name: String
    var subType: String?
    var displayName: String
    var streak: Int
    var streakHistory: [[Date]]
    var answerHistory: [Date: Bool]
    var mistakes: [Date:String]
    
    convenience init(
        breed: Breed,
        streak: Int = 0,
        streakHistory: [[Date]] = [],
        answerHistory: [Date : Bool] = [:],
        mistakes: [Date:String] = [:]
        
    ) {
        self.init(
            name: breed.name,
            subType: breed.subType,
            displayName: breed.displayName,
            streak: streak,
            streakHistory: streakHistory,
            answerHistory: answerHistory,
            mistakes: mistakes
        )
    }
    
    init(
        name: String,
        subType: String? = nil,
        displayName: String,
        streak: Int = 0,
        streakHistory: [[Date]] = [],
        answerHistory: [Date : Bool],
        mistakes: [Date:String] = [:]
    ) {
        self.name = name
        self.subType = subType
        self.displayName = displayName
        self.streak = streak
        self.streakHistory = streakHistory
        self.answerHistory = answerHistory
        self.mistakes = mistakes
    }
}
