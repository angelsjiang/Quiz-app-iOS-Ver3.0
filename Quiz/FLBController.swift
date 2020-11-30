//
//  FLBController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/24/20.
//

import UIKit

class FLBController: UIViewController, UITextFieldDelegate {
    
    // FLB
    @IBOutlet var FLBQuestionLabel: UILabel!
    @IBOutlet var FLBNextBtn: UIButton!
    @IBOutlet var FLBSubmitBtn: UIButton!
    @IBOutlet var usrData: UITextField!
    @IBOutlet var questionImage: UIImageView!
    var imageStore: ImageStore!
    
        
    var FLBQuestions = TriviaQuestionsStock.sharedInstance
    
    var currentQuestionIndex: Int = 0
    
    
    let correctAlertContent = NSAttributedString(string: "That was correct!", attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
        NSAttributedString.Key.foregroundColor : UIColor.green])
    let correctAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    let wrongAlertContent = NSAttributedString(string: "Sorry that was incorrect!", attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
        NSAttributedString.Key.foregroundColor : UIColor.red])
    let wrongAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil,
           replacementTextHasDecimalSeparator != nil {
            return false
            
        } else {
            return true
        }
    }
    
    func detectChange() {
        print("hello!")
    }
    
    @IBAction func checkForEmpty(_ sender: UIButton) {
        
        if usrData.text == FLBQuestions.questionArray[currentQuestionIndex].answer {
            Resources.resources.flbScore += 1
            Resources.resources.correctAns += 1
            
            correctAlert.setValue(correctAlertContent, forKey: "attributedTitle")
            self.present(correctAlert, animated: true, completion: {
                self.correctAlert.view.superview?.isUserInteractionEnabled = true
                self.correctAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertBackgroundTapped)))
            })
        }
        else {
            Resources.resources.wrongAns += 1
            wrongAlert.setValue(wrongAlertContent, forKey: "attributedTitle")
            self.present(wrongAlert, animated: true, completion: {
                self.wrongAlert.view.superview?.isUserInteractionEnabled = true
                self.wrongAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertBackgroundTapped)))
            })

        }
        
        if currentQuestionIndex >= (FLBQuestions.questionArray.count - 1) {
            print("in checkForEmpty if: ", currentQuestionIndex)

            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3
            
            FLBSubmitBtn.isEnabled = false
            FLBSubmitBtn.alpha = 0.3
        }
        else {
            print("in checkForEmpty else: ", currentQuestionIndex)
            FLBNextBtn.isEnabled = true
            FLBNextBtn.alpha = 1

            FLBSubmitBtn.isEnabled = false
            FLBSubmitBtn.alpha = 0.3
        }
        
    }
    

    // to dismiss alert
    @objc func alertBackgroundTapped () {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showNextQuest(_ sender: UIButton) {

        currentQuestionIndex += 1

        if currentQuestionIndex < FLBQuestions.questionArray.count {
            // need to find a way to prevent index going out of bound
            FLBQuestionLabel.text = FLBQuestions.questionArray[currentQuestionIndex].question
            usrData.text = ""
            let image = imageStore.image(forKey:
                                            FLBQuestions.questionArray[currentQuestionIndex].imageKey)
            print("imagekey is: " + FLBQuestions.questionArray[currentQuestionIndex].imageKey)
            // put the image on the screen
            questionImage.image = image

            
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3
            FLBSubmitBtn.isEnabled = true
            FLBSubmitBtn.alpha = 1

        }
        else {
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3

            FLBSubmitBtn.isEnabled = false
            FLBSubmitBtn.alpha = 0.3
        }
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        
        currentQuestionIndex = 0
        FLBQuestionLabel.text = FLBQuestions.questionArray[currentQuestionIndex].question
        
        FLBNextBtn.isEnabled = false
        FLBNextBtn.alpha = 0.3

    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        usrData.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FLBQuestions.questionArray.count == 0 {
            FLBQuestionLabel.text = "Question..."
            questionImage.image = nil
            
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3

            FLBSubmitBtn.isEnabled = false
            FLBSubmitBtn.alpha = 0.3

        }
        else {
            FLBQuestionLabel.text = FLBQuestions.questionArray[currentQuestionIndex].question
            questionImage.image = imageStore.image(forKey:
                                                    FLBQuestions.questionArray[currentQuestionIndex].imageKey)
            
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3
            FLBSubmitBtn.isEnabled = true
            FLBSubmitBtn.alpha = 1

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if FLBQuestions.questionArray.count == 0 {
            usrData.text = ""
            FLBQuestionLabel.text = "Question..."
            questionImage.image = nil
            
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3

            FLBSubmitBtn.isEnabled = false
            FLBSubmitBtn.alpha = 0.3

        }
        else {
            print("from FLBController: ", currentQuestionIndex)
            FLBQuestions = TriviaQuestionsStock.sharedInstance
            FLBQuestionLabel.text = FLBQuestions.questionArray[currentQuestionIndex].question
            questionImage.image = imageStore.image(forKey:
                                                    FLBQuestions.questionArray[currentQuestionIndex].imageKey)
            
            FLBSubmitBtn.isEnabled = true
            FLBSubmitBtn.alpha = 1
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3

        }

        
        // if reset is true
        if Resources.resources.FLBReset {
            currentQuestionIndex = 0
            FLBQuestionLabel.text = FLBQuestions.questionArray[currentQuestionIndex].question
            questionImage.image = imageStore.image(forKey:
                                                    FLBQuestions.questionArray[currentQuestionIndex].imageKey)

            usrData.text = ""
            
            FLBNextBtn.isEnabled = false
            FLBNextBtn.alpha = 0.3
            
            FLBSubmitBtn.isEnabled = true
            FLBSubmitBtn.alpha = 1

            
            // set it to false so it doesnt reset every time
            Resources.resources.FLBReset = false
            
        }
    }
}
