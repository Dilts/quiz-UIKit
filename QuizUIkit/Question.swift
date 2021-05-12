//
//  Question.swift
//  QuizUIkit
//
//  Created by Brian Dilts on 5/11/21.
//

import Foundation

struct Question: Codable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
    
}
