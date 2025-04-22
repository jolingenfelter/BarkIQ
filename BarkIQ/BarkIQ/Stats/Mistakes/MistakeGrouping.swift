//
//  MistakeGrouping.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation

enum MistakeGrouping {
    /// Takes a list of wrong answers (just the breed names) and groups
    /// them by breed, returning a sorted list with the most frequent mistakes first.
    static func groupedMistakes(from mistakes: [String]) -> [(breed: String, count: Int)] {
        Dictionary(grouping: mistakes, by: { $0 })
            .map { (key, group) in (breed: key, count: group.count) }
            .sorted { $0.count > $1.count }
    }
    
    /// Groups mistakes by the date they happened. Returns a dictionary
    /// where the key is a short formatted date string (like "Apr 21"),
    /// and the value is a list of breeds that a particular breed was mistaken for
    /// on that day.
    static func groupMistakesByDate(_ history: [Date: String]) -> [String: [String]] {
           Dictionary(grouping: history) { (date, _) in
               date.formatted(date: .abbreviated, time: .omitted)
           }
           .mapValues { $0.map(\.value) }
       }
}
