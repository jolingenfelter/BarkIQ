//
//  MistakeGroupingTests.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation
import Testing

@testable import BarkIQ

struct MistakeGroupingTests {
    @Test func testBreedGroupingCountsCorrectly() {
        let mock = ["Poodle", "Poodle", "Beagle", "Golden Retriever", "Beagle"]
        let grouped = MistakeGrouping.groupedMistakes(from: mock)

        #expect(grouped.count == 3, "Expected 3 groups, got \(grouped.count)")
        #expect(grouped.contains(where: { $0.breed == "Poodle" && $0.count == 2 }), "Expected to find 2 Poodles.")
        #expect(grouped.contains(where: { $0.breed == "Beagle" && $0.count == 2 }), "Expected to find 2 Beagles.")
        #expect(grouped.contains(where: { $0.breed == "Golden Retriever" && $0.count == 1 }), "Expected to find 1 Golden Retriever")
    }
    
    @Test func testGroupMistakesByDateProducesCorrectGroups() {
        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        // All dates on the same day, just different times
        let morning = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let evening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!
        
        // Different days
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now)!

        let mistakes: [Date: String] = [
            morning: "Beagle",
            evening: "Beagle",
            yesterday: "Poodle",
            twoDaysAgo: "Dachshund"
        ]

        let grouped = MistakeGrouping.groupMistakesByDate(mistakes)

        let todayKey = formatter.string(from: now)
        let yesterdayKey = formatter.string(from: yesterday)
        let twoDaysAgoKey = formatter.string(from: twoDaysAgo)

        #expect(grouped.count == 3, "Expected 3 date groups, found \(grouped.count)")

        if let todayMistakes = grouped[todayKey] {
            #expect(todayMistakes.count == 2, "Expected 2 mistakes for today, found \(todayMistakes.count)")
            #expect(todayMistakes.allSatisfy { $0 == "Beagle" }, "Expected only Beagle mistakes for today")
        } else {
            Issue.record("Expected to find a group for today (\(todayKey))")
        }

        #expect(grouped[yesterdayKey]?.first == "Poodle")
        #expect(grouped[twoDaysAgoKey]?.first == "Dachshund")
    }
}
