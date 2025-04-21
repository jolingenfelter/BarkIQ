//
//  BreedStats+QuestionResult.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

extension BreedStats {
    func update(for result: QuestionResult) {
        if result.isCorrect {
            appendCorrectResponse()
        } else {
            appendIncorrectResponse(mistakenFor: result.selectedAnswer.displayName)
        }
    }
}
