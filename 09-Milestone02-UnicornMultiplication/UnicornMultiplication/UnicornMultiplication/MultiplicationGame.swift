//
//  MultiplicationGame.swift
//  UnicornMultiplication
//
//  Created by Cyberwool on 6/8/24.
//

import Foundation

struct MultiplicationGame {
    private(set) var numberOfQuestions: Int
    private(set) var questions: [MultiplicationGameQuestion]
    private(set) var score: Int = 0
    var nextQuestion: MultiplicationGameQuestion? {
        if questions.count > 0 {
            return questions[0]
        } else {
            return nil
        }
    }
    
    init(numberOfQuestions: Int?, questionRange: ClosedRange<Int>) {
        // Create questions
        questions = [MultiplicationGameQuestion]()
        for factorOne in questionRange {    // [1, 2, 3, 4]
            for factorTwo in questionRange {    // [1, 2, 3, 4]
                // 1 1, 1 2, 1 3, 1 4, ...
                questions.append(MultiplicationGameQuestion(factorOne: factorOne, factorTwo: factorTwo))
            }
        }
        questions.shuffle()
        
        // Assign number of questions
        if let questionCount = numberOfQuestions, questionCount > 0 {
            questions = Array(questions.prefix(questionCount))
        }
        self.numberOfQuestions = questions.count
        
        // Generate answers for questions here, after we've cut off ones we're not using (above)
        for i in 0..<questions.count {
            questions[i].generateAnswers()
        }
    }
    
    mutating func guess(answer: Int) {
        if answer == questions[0].answer {
            score += 1
        }
        questions.remove(at: 0)
    }
}

struct MultiplicationGameQuestion {
    private(set) var factorOne: Int
    private(set) var factorTwo: Int
    var answer: Int {
        factorOne * factorTwo
    }
    private(set) var possibleAnswers: [Int] = [Int]()
    
    init(factorOne: Int, factorTwo: Int) {
        self.factorOne = factorOne
        self.factorTwo = factorTwo
    }
    
    private func getDecoyAnswer() -> Int {
        Int.random(in: 1...12) * Int.random(in: 1...12)
    }
    
    mutating fileprivate func generateAnswers() {
        var answers = [answer]
        for _ in 0...3 {
            var decoyAnswer = getDecoyAnswer()
            while (answers.contains(decoyAnswer)) {
                decoyAnswer = getDecoyAnswer()
            }
            answers.append(decoyAnswer)
        }
        answers.shuffle()
        self.possibleAnswers = answers
    }
    
}
