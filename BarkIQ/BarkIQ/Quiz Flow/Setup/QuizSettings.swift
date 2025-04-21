//
//  QuizSettings.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

struct QuizSettings: Hashable, Equatable {
    let countOptions = Array(stride(from: 5, through: 25, by: 5))
    
    var questionCount: Int
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
