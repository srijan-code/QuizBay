//
//  StaticContestAPIManager.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 08/08/22.
//

import UIKit
import Foundation

protocol StaticContestManagerDelegate {
    func updateData(contestDetail: [ContestModel])
}

class StaticContestAPIManager: UIViewController {
    var delegate: StaticContestManagerDelegate?
    func fetchContestList()
    {
        let urlString =  "http://10.20.3.120:8111/contest/contest/static"
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
                        self?.delegate?.updateData(contestDetail: fetchedData)
                    }
                }
            }
            task.resume()
        } else {
            print("Failed to parse URL String: \(urlString)")
        }
    }
    
    func parseJSON(_ contestData: Data) -> [ContestModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ContestModel].self, from: contestData)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
