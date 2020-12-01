//
//  TriviaQuestion.swift
//  Quiz
//
//  Created by Angel Jiang on 11/26/20.
//

import UIKit

class TriviaQuestion: Equatable, Codable {
    
    var question: String
    var answer: String
    let date: String
    let imageKey: String
//    var drawing = [Line]()
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium

        self.date = formatter.string(from: currentDate)

        self.imageKey = UUID().uuidString
    }

    
    static func ==(lhs: TriviaQuestion, rhs: TriviaQuestion) -> Bool {
        return lhs.question == rhs.question
            && lhs.answer == rhs.answer 
    }
}
