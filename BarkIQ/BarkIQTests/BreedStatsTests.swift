//
//  BreedStatsTests.swift
//  BarkIQTests
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import Foundation
import Testing

@testable import BarkIQ

struct BreedStatsTests {
    @Test func testCorrectAnswerIncrementsStreak() {
        let stats = BreedStats(breed: .mock1)
        stats.appendCorrectResponse(date: .now)
        
        #expect(stats.streak == 1, "Expected a streak of 1, but got \(stats.streak) instead.")
        #expect(stats.answerHistory.count == 1, "Expected an answerHistory with one value, but got \(stats.answerHistory.count) instead")
        #expect(stats.streakHistory.count == 1, "Expected a streak history of 1, but got \(stats.streakHistory.count) instead")
        #expect(stats.streakHistory[0].count == 1, "Expected the first streak to have 1 value, but got \(stats.streakHistory[0].count) instead.")
    }
    
    @Test func testIncorrectAnswerResetsStreak() {
        let stats = BreedStats(breed: .mock1)
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        
        #expect(stats.streak == 0, "Expected streak to reset to 0, but got \(stats.streak) instead")
        #expect(stats.answerHistory.count == 3, "Expected an answer history with 3 entries, but found \(stats.answerHistory.count) instead.")
        #expect(stats.streakHistory.count == 1, "Expected to find one streak history, but found \(stats.streakHistory.count) instead") // Still keeps the one streak
    }
    
    @Test func testMediumConfidenceWithHistoricStreak() {
        let stats = BreedStats(breed: .mock1)
        
        // Historic streak of 3
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        
        // Accuracy: 3/4 = 0.75 with a broken streak
        #expect(stats.confidence == .medium, "Expected medium confidence but got \(stats.confidence.rawValue) instead.")
    }
    
    
    @Test func testLowConfidenceWhenMostlyIncorrect() {
        let stats = BreedStats(breed: .mock1)
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        
        #expect(stats.confidence == .low, "Expected low confidence but got \(stats.confidence.rawValue) instead.")
    }
    
    @Test func testHighConfidenceWithBrokenHistoricStreak() {
        let stats = BreedStats(breed: .mock1)
        
        // Historic streak of 6
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()
        
        // Break the streak
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        
        // Accuracy 6/7
        #expect(stats.confidence == .high, "Expected high confidence but got \(stats.confidence.rawValue) instead.")
    }
    
    @Test func testAccuracyCalculation() {
        let stats = BreedStats(breed: .mock1)

        stats.appendCorrectResponse()
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)
        stats.appendCorrectResponse()

        // 2 correct out of 3
        #expect(stats.accuracy == 2.0 / 3.0, "Expected accuracy of 0.666... but got \(stats.accuracy)")
    }
    
    @Test func testMostRecentAnswerDate() throws {
        let stats = BreedStats(breed: .mock1)

        let earlier = Date(timeIntervalSinceNow: -60)
        let later = Date()

        stats.appendCorrectResponse(date: earlier)
        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName, date: later)
        
        let mostRecentAnswerDate = try #require(stats.mostRecentAnswerDate, "Expected a non-nil most recent answer date.")

        #expect(stats.mostRecentAnswerDate == later, "Expected most recent answer date to be \(later), but got \(mostRecentAnswerDate) instead.")
        
        let firstAnswerDate = try #require(stats.firstAnswerDate, "Expected a non-nil first answer date.")
        #expect(stats.firstAnswerDate == earlier, "Expected first answer date to be \(earlier), but got \(firstAnswerDate) instead.")
    }
    
    @Test func testLongestStreakCorrectlyComputed() {
        let stats = BreedStats(breed: .mock1)

        stats.appendCorrectResponse() // streak of 3
        stats.appendCorrectResponse()
        stats.appendCorrectResponse()

        stats.appendIncorrectResponse(mistakenFor: Breed.mock1.displayName)

        stats.appendCorrectResponse() // streak of 2
        stats.appendCorrectResponse()

        #expect(stats.longestRunningStreak == 3, "Expected longest streak of 3 but got \(stats.longestRunningStreak)")
    }
}
