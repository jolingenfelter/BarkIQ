//
//  MistakeGrouping.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation

enum MistakeGrouping {
    static func groupedMistakes(from mistakes: [String]) -> [(breed: String, count: Int)] {
        Dictionary(grouping: mistakes, by: { $0 })
            .map { (key, group) in (breed: key, count: group.count) }
            .sorted { $0.count > $1.count }
    }
    
    static func groupMistakesByDate(_ history: [Date: String]) -> [String: [String]] {
           Dictionary(grouping: history) { (date, _) in
               date.formatted(date: .abbreviated, time: .omitted)
           }
           .mapValues { $0.map(\.value) }
       }
}
