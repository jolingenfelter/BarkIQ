//
//  BreedStats+Confidence.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

extension BreedStats {
    var confidence: ConfidenceLevel {
        let greenStreak = streak >= 3
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
    
    static let mockLowConfidence1: BreedStats =
        .init(
            breed: .mock1,
            streak: 0,
            streakHistory: [[.now]],
            answerHistory: [.now : false]
        )
    
    static let mockLowConfidence2: BreedStats =
        .init(
            breed: .mock2,
            streak: 0,
            streakHistory: [[.now]],
            answerHistory: [.now : false]
        )
    
    static let mockCollection: [BreedStats] = [
        .mockLowConfidence1,
        .mockLowConfidence2
    ]
}
