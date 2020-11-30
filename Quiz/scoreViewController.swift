//
//  scoreViewController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/24/20.
//

import UIKit

class scoreViewController: UIViewController {
    
    @IBOutlet var score: UILabel!
    
    var usrScore = 0
    var correctAnswer = 0
    var wrongAnswer = 0

    override func viewWillAppear(_ animated: Bool) {
        
        usrScore = Resources.resources.mcqScore + Resources.resources.flbScore
        
        if usrScore == 0 {
            score.text = "0"
        }
        else {
            score.text = String(usrScore)
        }
        
        correctAnswer = Resources.resources.correctAns
        wrongAnswer = Resources.resources.wrongAns
        if correctAnswer > wrongAnswer {
            // green bg
            self.view.backgroundColor = .green
        }
        else if correctAnswer == wrongAnswer {
            // white bg
            self.view.backgroundColor = .white
        }
        else {
            // red bg
            self.view.backgroundColor = .red
        }
        
        print(usrScore)
    }
}
