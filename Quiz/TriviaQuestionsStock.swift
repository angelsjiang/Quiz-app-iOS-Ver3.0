//
//  TriviaQuestionsStock.swift
//  Quiz
//
//  Created by Angel Jiang on 11/26/20.
//

import UIKit

class TriviaQuestionsStock {
    
    static let sharedInstance = TriviaQuestionsStock()
    
    var questionArray: [TriviaQuestion] = [
//        TriviaQuestion(question: "How many elements are on the Periodic table?", answer: "118"),
//        TriviaQuestion(question: "How many members are in the K-pop group named BTS?", answer: "7"),
//        TriviaQuestion(question: "On average, how many seeds does a strawberry have on its surface?", answer: "200"),
//        TriviaQuestion(question: "How many members were there in The Beatles?", answer: "4"),
//        TriviaQuestion(question: "Approximately how many percent of the human body is made up of water?", answer: "60"),
//        TriviaQuestion(question: "How many Inifinity Stones feature in the Marvel Cinematic Universe films?", answer: "6"),
//        TriviaQuestion(question: "Which day of July is Canada Day?", answer: "1")
    ]
    
    let questionArchiveUrl: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("quesitons.plist")
    }()
    
    // create
    func createQuestion(question: String, answer: String) {
        let triviaQuestion = TriviaQuestion(question: question, answer: answer)
        
        questionArray.append(triviaQuestion)
        
    }
    

    // add a notification observer
    init() {
        do {
            let data = try Data(contentsOf: questionArchiveUrl)
            let unarchiver = PropertyListDecoder()
            let questions = try unarchiver.decode([TriviaQuestion].self, from: data)
            questionArray = questions
            
        } catch {
            print("Error reading in saving questions: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }

    
    // adding a question
    @discardableResult func createItem() -> TriviaQuestion {
        // create blank question
        let newQuestion = TriviaQuestion(question: "Blank", answer: "Blank")
        
        questionArray.append(newQuestion)
        
        return newQuestion
    }
    
    
    // remove an item, might not use
    func removeItem(_ question: TriviaQuestion) {
        if let index = questionArray.firstIndex(of: question) {
            questionArray.remove(at: index)
        }
    }
    
    
    // reordering item
    func reOrdering(from fromIndex: Int, to toIndex: Int ) {
        // in case if the question is placed at the exact same position
        if fromIndex == toIndex {
            return
        }
        
        let movedQuestion = questionArray[fromIndex]
        
        questionArray.remove(at: fromIndex)
        
        questionArray.insert(movedQuestion, at: toIndex)
    }
    
    
    // to persist question data
    @objc func  saveChanges() -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(questionArray)
            try data.write(to: questionArchiveUrl, options: [.atomic])
            print("Saved all of the data")
            return true
            
        } catch let encodingError{
            print("Error encoding questionArray: \(encodingError)")
            return false
        }
    }
    
}
