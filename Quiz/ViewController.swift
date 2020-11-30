//
//  ViewController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/21/20.
//

import UIKit

class MCQController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MCQ
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var answers: UIPickerView!
    

    let questions: [String] = [
        "How many stripes are on the American flag?",
        "How many wisdom teeth does the average human have?",
        "In The Little Mermaid Disney cartoon, how many sisters does Ariel have?"
    ]
    
    let pickerDataSet1: [[String]] = [["8", "13", "25", "50"], ["2", "4", "6", "8"], ["2", "4", "5", "6"]]

    // initialize the set of questions and answers to be delivered, should increment after user click "Next question"
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex != questions.count {
            let question: String = questions[currentQuestionIndex]
            questionLabel.text = question
            answers.reloadAllComponents()
        }
        else if currentQuestionIndex == questions.count{
            nextBtn.isEnabled = false
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data
        self.answers.delegate = self
        self.answers.dataSource = self
        
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // to dispose of any resources that acn be recreated
    }
    
    // Data number column
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerDataSet1[currentQuestionIndex].count
    }
    
    // data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSet1[currentQuestionIndex][row]
    }

}

