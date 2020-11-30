//
//  QuestionsViewController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/25/20.
//

import UIKit

class QuestionsViewController: UITableViewController {
    
    var triviaQuestions = TriviaQuestionsStock.sharedInstance
    var imageStore: ImageStore!
    var addNewQuestion: Bool = false
    var detailViewController: DetailViewController!

    
    
    // adding edit button
    required init?(coder decoder: NSCoder) {
        super.init(coder:  decoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        if isEditing {
            super.setEditing(false, animated: true)
            
        }
        
        else {
            super.setEditing(true, animated: true)
            
            // need to reset all the scores & questions
            Resources.resources.FLBReset = true
            Resources.resources.MCQReset = true

            // reset scores
            Resources.resources.correctAns = 0
            Resources.resources.wrongAns = 0
            Resources.resources.flbScore = 0
            Resources.resources.mcqScore = 0
        }
    }
    
    
    // implementing table view row deletion
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let question = triviaQuestions.questionArray[indexPath.row]
            
            triviaQuestions.questionArray.remove(at: indexPath.row)
            
            // also remove image from cache
            imageStore.deleteImage(forKey: question.imageKey)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // implementing table view row reordering
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        triviaQuestions.reOrdering(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return triviaQuestions.questionArray.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell",
                                                 for: indexPath) as! QuestionCell
        
        let item = triviaQuestions.questionArray[indexPath.row]
        
        cell.questionLabel.text = item.question
        cell.answerLabel.text = item.answer
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
    }
    
    
    // get the updated table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showQuestion":
            if let row = tableView.indexPathForSelectedRow?.row {
                let question = triviaQuestions.questionArray[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.triviaQuestion = question
                detailViewController.imageStore = imageStore
            }
        case "newQuestion":
            if segue.destination is DetailViewController {
                let dvc = segue.destination as? DetailViewController
                let newQuestion = triviaQuestions.createItem()
                dvc?.triviaQuestion = newQuestion
                dvc?.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}
