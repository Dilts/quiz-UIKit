//
//  ViewController.swift
//  QuizUIkit
//
//  Created by Brian Dilts on 5/11/21.
//

import UIKit

class ViewController: UIViewController, QuizProtocol {
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        model.delegate = self
        model.getQuestions()
    }
    
    //MARK: - Quiz Protocol Methods
    func questionsRetrieved(_ questions: [Question]) {
        print("questions retrieved from model")
    }

}

