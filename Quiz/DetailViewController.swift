//
//  DetailViewController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/28/20.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,
                            UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var triviaQuestionStock: TriviaQuestionsStock!
    var toAddNewQuestion: Bool = false
    
    
    var triviaQuestion: TriviaQuestion! {
        didSet {
            navigationItem.title = triviaQuestion.question
        }
    }
    var imageStore: ImageStore!
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    // function to choose image, either from camera if available, or photo library
    @IBAction func chooseImageSource(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        // to check if camera is availabe at this current device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                imagePicker.modalPresentationStyle = .popover
                imagePicker.popoverPresentationController?.barButtonItem = sender
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        
        let imageLibraryAction = UIAlertAction(title: "Image Library", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(imageLibraryAction)
        
        // check to see if there is an imageKey present
        if imageStore.image(forKey: triviaQuestion.imageKey) != nil {
            let removeImageAction = UIAlertAction(title: "Remove Image", style: .destructive) { _ in
                self.imageStore.deleteImage(forKey: self.triviaQuestion.imageKey)
                self.imageView.image = nil
            }
            alertController.addAction(removeImageAction)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // imagePicker
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    
    // function to set up the image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        
        // store the image in imageStore
        print("Question image key is: ", triviaQuestion.imageKey)
        imageStore.setImage(image, forKey: triviaQuestion.imageKey)
        
        // put the image on the screen
        imageView.image = image
        
        // take imagePicker off the screen
        dismiss(animated: true, completion: nil)
    }
    
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("from DetailViewController: ", toAddNewQuestion)
        
        if toAddNewQuestion {
            let newQuestion = triviaQuestionStock.createItem()
            triviaQuestion = newQuestion
        }
        
        
        questionField.text = triviaQuestion.question
        answerField.text = triviaQuestion.answer
        dateLabel.text = dateFormatter.string(from: triviaQuestion.date)
        
        // Get the item key
        let key = triviaQuestion.imageKey
        
        let imageToBeDisplayed = imageStore.image(forKey: key)
        imageView.image = imageToBeDisplayed
        
    }
    
    // saves changes into question
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear firstResponder, dismiss keyboard
        view.endEditing(true)
        
        triviaQuestion.question = questionField.text ?? ""
        triviaQuestion.answer = answerField.text ?? ""
        
//        drawView.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DrawViewController {
            // pass in the trivia question, including the imageStore
            let drawViewController = segue.destination as! DrawViewController
            drawViewController.triviaQuestion = self.triviaQuestion
            drawViewController.imageStore = self.imageStore
        }
    }
}
