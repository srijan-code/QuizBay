//
//  ValidateContestAPIManager.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 10/08/22.
//

import UIKit

protocol ValidationCheckManagerDelegate {
    func updateData(isValid: Bool)
}

class ValidateContestAPIManager: UIViewController {

    var delegate: ValidationCheckManagerDelegate?
    func fetchContestList(id: String)
    {
        if let playerId = UserDefaults.standard.string(forKey: "playerId"){
        let urlString =  "http://10.20.3.120:8111/contest/start/\(id)/\(playerId)"
        performRequest(with: urlString)
        }
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
                        self?.delegate?.updateData(isValid: fetchedData)
                    }
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL String: \(urlString)")
        }
    }
    
    func parseJSON(_ contestData: Data) -> Bool? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Bool.self, from: contestData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
