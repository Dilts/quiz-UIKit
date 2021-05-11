//
//  ViewController.swift
//  QuizUIkit
//
//  Created by Brian Dilts on 5/11/21.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set self as the delegate and datasource for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set up the model
        model.delegate = self
        model.getQuestions()
    }
    
    //MARK: - Quiz Protocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        
        // Get reference to the questions
        self.questions = questions
        
        // Reload the tableview
        tableView.reloadData()
        
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
            // TODO: Set the answer text for the label
        }
        
        // Return the cell
        return cell
    }
    
    
}

