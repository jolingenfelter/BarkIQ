//
//  BreedStats+Confidence.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

extension BreedStats {
    /// Returns a confidence level based on the user's performance with this breed.
    ///
    /// Confidence is determined by combining recent streaks and overall accuracy,
    /// with a bias toward sustained performance over time.
    ///
    /// - High confidence is returned if:
    ///   - The current streak is 5 or more correct answers, OR
    ///   - The user has previously had a streak of 5+ and maintains ≥ 85% accuracy overall.
    ///
    /// - Medium confidence is returned if:
    ///   - The current streak is at least 1, OR
    ///   - The user has previously had a streak of 2+ and maintains ≥ 70% accuracy.
    ///
    /// - Low confidence is returned if neither high nor medium thresholds are met.
    var confidence: ConfidenceLevel {
        let greenStreak = streak >= 5
        let historicGreenStreek = !streakHistory.filter { $0.count >= 3 }.isEmpty
        let greenAccuracy = accuracy >= 0.85
        let greenException = historicGreenStreek && greenAccuracy
        
        let yellowStreak = streak >= 1
        let historicYellowStreak = !streakHistory.filter { $0.count >= 2 }.isEmpty
        let yellowAccuracy = accuracy >= 0.7
        let yellowException = historicYellowStreak && yellowAccuracy
        
        if greenStreak || greenException {
            return .high
        } else if yellowStreak || yellowException {
            return .medium
        } else {
            return .low
        }
    }
    
    // MARK: - Low Confidence
    
    static let mockLowConfidence1: BreedStats =
        .init(
            breed: .mock1,
            streak: 0,
            streakHistory: [[.now]],
            answerHistory: [.now : false],
            mistakes: [.now: "Boxer"]
        )
    
    static let mockLowConfidence2: BreedStats =
        .init(
            breed: .mock2,
            streak: 0,
            streakHistory: [[.now]],
            answerHistory: [.now : false],
            mistakes: [.now: "Boxer"]
        )
    
    
    // MARK: - Medium Confidence
    
    static let mockMediumConfidence1 = BreedStats(
        breed: .mock3,
        streak: 1,
        streakHistory: [[.now.addingTimeInterval(-400)]],
        answerHistory: [
            .now.addingTimeInterval(-700): false,
            .now.addingTimeInterval(-400): true
        ],
        mistakes: [.now: "Boxer"]
    )
    
    static let mockMediumConfidence2 = BreedStats(
        breed: .mock4,
        streak: 1,
        streakHistory: [[.now.addingTimeInterval(-300)]],
        answerHistory: [
            .now.addingTimeInterval(-900): false,
            .now.addingTimeInterval(-600): true,
            .now.addingTimeInterval(-300): true
        ],
        mistakes: [.now: "Boxer"]
    )
    
    // MARK: - High Confidence
    
    static let mockHighConfidence1 = BreedStats(
        breed: .mock5,
        streak: 4,
        streakHistory: [
            [
                .now.addingTimeInterval(-4000),
                .now.addingTimeInterval(-3000),
                .now.addingTimeInterval(-2000),
                .now.addingTimeInterval(-1000)
            ]
        ],
        answerHistory: [
            .now.addingTimeInterval(-4000): true,
            .now.addingTimeInterval(-3000): true,
            .now.addingTimeInterval(-2000): true,
            .now.addingTimeInterval(-1000): true
        ],
        mistakes: [.now: "Boxer"]
    )
    
    static let mockHighConfidence2 = BreedStats(
        breed: .mock6,
        streak: 3,
        streakHistory: [
            [.now.addingTimeInterval(-1000), .now.addingTimeInterval(-500), .now]
        ],
        answerHistory: [
            .now.addingTimeInterval(-1000): true,
            .now.addingTimeInterval(-500): true,
            .now: true
        ],
        mistakes: [.now: "Boxer"]
    )
    
    // MARK: - Full Collection
    
    static let mockCollection: [BreedStats] = [
        .mockLowConfidence1,
        .mockLowConfidence2,
        .mockMediumConfidence1,
        .mockMediumConfidence2,
        .mockHighConfidence1,
        .mockHighConfidence2
    ]
}
