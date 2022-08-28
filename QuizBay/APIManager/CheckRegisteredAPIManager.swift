//
//  CheckRegisteredAPIManager.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 10/08/22.
//

import UIKit

protocol RegistrationCheckManagerDelegate {
    func updateData(checkDetail: Bool)
}

class CheckRegisteredAPIManager: UIViewController {

    var delegate: RegistrationCheckManagerDelegate?
    func fetchContestList(contestId: String)
    {
        if let playerId = UserDefaults.standard.string(forKey: "playerId"){
        let urlString =  "http://10.20.3.120:8111/subscription/\(playerId)/\(contestId)"
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
                        self?.delegate?.updateData(checkDetail: fetchedData)
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
            let decodedData = try decoder.decode(Registered?.self, from: contestData)
            var hasRegistered = false
            
            if decodedData == nil{
                hasRegistered = true
            }
            return hasRegistered
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
