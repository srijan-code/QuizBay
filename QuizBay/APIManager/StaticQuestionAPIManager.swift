//
//  StaticQuestionAPIManager.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 06/08/22.
//

import Foundation
import UIKit

protocol StaticQuestionManagerDelegate {
    func updateData(questionDetail: Question)
}

class StaticQuestionAPIManager: UIViewController
{
    var delegate: StaticQuestionManagerDelegate?
    func fetchQuestionList(questionId: String)
    {
        let urlString =  "http://10.20.3.120:8111/question/id/\(questionId)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)
    {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
            let task = session.dataTask(with: request){
                [weak self] (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let safeData = data{
                    print("URL: \(urlString) succesful, withData: \(safeData)")
                    if let fetchedData = self?.parseJSON(safeData){
                        self?.delegate?.updateData(questionDetail: fetchedData)
                    }
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL String: \(urlString)")
        }
    }
    
    func parseJSON(_ questionData: Data) -> Question? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Question.self, from: questionData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}




