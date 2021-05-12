//
//  ViewController.swift
//  QuizUIkit
//
//  Created by Brian Dilts on 5/11/21.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog:ResultViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        // Set self as the delegate and datasource for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Dynamic row heights done programatically
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set up the model
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
        // Check if there are questions and check that the current question index is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        // Display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        // Reload the answers table
        tableView.reloadData()
        
    }
    
    
    //MARK: - Quiz Protocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        
        // Get reference to the questions
        self.questions = questions
        
        // Check if we should restore the state before showing question #1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            // Set the current question to the saved index
            currentQuestionIndex = savedIndex!
            
            // Retrieve the number correct from storage
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as! Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect
            }
        }
        
        // Display the first question
        displayQuestion()
        
    }
    
    //MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure the questions array contains a question
        guard questions.count > 0 else {
            return 0
        }
        
        // Return the number of answers for this question
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Customize it
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            // Set the answer text for the label
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                
                // Set the answer text for the label
                label!.text = question.answers![indexPath.row]
                
            }
            
        }
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        // User has tapped on a row, check that it is the right answer
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            
            // User got it right
            print("User got it right")
            titleText = "Correct!!!"
            numCorrect += 1
        }else {
            
            // User got it wrong
            print("WRONG Sucker!!!")
            titleText = "Wrong! Boo!!"
        }
        
        // Show the popup
        if resultDialog != nil {
            
            // Customize the dialog text
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            present(resultDialog!, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - ResultViewControllerProtocol Methods
    
    func dialogDismissed() {
        
        // Increment the current question index
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            // The user has just answered the last question
            // Show a summary dialog
            // Show the popup
            if resultDialog != nil {
                
                // Customize the dialog text
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count) questions"
                resultDialog!.buttonText = "Restart"
                
                present(resultDialog!, animated: true, completion: nil)
                
                // Clear the state
                StateManager.clearState()
            }
            
        }else if currentQuestionIndex > questions.count{
            // Restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        else if currentQuestionIndex < questions.count {
            // We have more questions to show
            // Display the next question
            displayQuestion()
            
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        
    }
    
    
}

