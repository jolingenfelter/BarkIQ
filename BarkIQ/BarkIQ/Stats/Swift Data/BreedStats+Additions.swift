//
//  BreedStats+Additions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import Foundation

extension BreedStats {
    static func newStatsEntry(forBreed breed: Breed) -> BreedStats {
        return BreedStats(breed: breed)
    }
    
    func appendCorrectResponse(date: Date = .now) {
        if streak != 0 {
            // Continue the previous streak
            streakHistory[streakHistory.count - 1].append(.now)
        } else {
            // Start a new streak
            streakHistory.append([date])
        }

        streak += 1
        answerHistory[date] = true
    }

    func appendIncorrectResponse(mistakenFor breed: String, date: Date = .now) {
        streak = 0
        answerHistory[date] = false
        mistakes[date] = breed
    }
    
    var repetitionCount: Int {
        answerHistory.count
    }
    
    var correctCount: Int {
        answerHistory.values.filter { $0 == true }.count
    }

    var incorrectCount: Int {
        answerHistory.values.filter { $0 == false }.count
    }

    var accuracy: Double {
        guard repetitionCount > 0 else {
            return 0
        }

        return (Double(correctCount)/Double(repetitionCount))
    }

    var datesAnswered: [Date] {
        var dates: [Date] = []
        for dateAnswer in answerHistory.keys {
            dates.append(dateAnswer)
        }

        return dates
    }

    var formattedHistory: [(String, Bool)] {
        var history: [(String, Bool)] = []
        for (key, value) in answerHistory {
            history.append((key.formatted(.dateTime.day().month().year()), value
                           ))
        }

        return history
    }

    var mostRecentAnswerDate: Date? {
        answerHistory.keys.max()
    }

    var lastCorrectDate: Date? {
        answerHistory.filter { $0.value == true }.map(\.key).max()
    }

    var lastInCorrectDate: Date? {
        answerHistory.filter { $0.value == false }.map(\.key).max()
    }

    var mostRecentAnswerValue: String {
        guard let mostRecentAnswerDate else {
            return ""
        }

        return mostRecentAnswerDate.formatted(.dateTime.day().month().year())
    }

    var firstAnswerDate: Date? {
        answerHistory.keys.min()
    }

    var firstAnswerValue: String {
        guard let firstAnswerDate else {
            return ""
        }

        return firstAnswerDate.formatted(.dateTime.day().month().year())
    }

    var longestRunningStreak: Int {
        streakHistory.map(\.count).max() ?? 0
    }
}
