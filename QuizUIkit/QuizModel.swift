//
//  QuizModel.swift
//  QuizUIkit
//
//  Created by Brian Dilts on 5/11/21.
//

import Foundation

protocol QuizProtocol {
    
    func questionsRetrieved(_ questions:[Question])
    
    
    
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        //Fetch the questions
        getLocalJsonFile()
        

        
    }
    
    func getLocalJsonFile() {
        
        // Get bundle path to json file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        // Double check that the path is not nil
        guard path != nil else {
            print("Couldn't find json data file")
            return
        }
        
        // Create URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            // Get the data from the URL
            let data = try Data(contentsOf: url)
            
            // Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Notify the delegate of the retrieved questions
            delegate?.questionsRetrieved(array)
            
        }
        catch {
            print("Couldn't download the data at that URL")
        }
        
        
        
    }
    
    func getRemoteJsonFile() {
        
    }
    
    
}
