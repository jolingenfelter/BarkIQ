//
//  QuizSettings.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

/// Stores configuration options for a quiz session, including the
/// number of questions and the list of available breeds to choose from.
/// Used to control quiz setup and question generation.
struct QuizSettings: Hashable, Equatable {
    /// The set of available question count options, shown in the picker during quiz setup.
    /// Defaults to [5, 10, 15, 20, 25].
    let countOptions = Array(stride(from: 5, through: 25, by: 5))
    
    /// The number of questions in a quiz
    var questionCount: Int
    
    /// The breeds available to generage questions from
    var breeds: [Breed] = []
    
    init() {
        self.questionCount = 5
        self.breeds = []
    }
    
    // Used for mocking
    init(questionCount: Int, breeds: [Breed] = []) {
        self.questionCount = questionCount
        self.breeds = breeds
    }
    
    static let mock: QuizSettings = .init(
        questionCount: 10,
        breeds: Breed.mockArray
    )
}
