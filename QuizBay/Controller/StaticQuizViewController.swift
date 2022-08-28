//
//  StaticQuizViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class StaticQuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StaticContestManagerDelegate,RegistrationCheckManagerDelegate {
    
    @IBOutlet weak var playerContest: UIButton!
    @IBOutlet weak var staticQuizCollectionView: UICollectionView!
    
    var hasRegistered: Bool = false
    var urlCaller: StaticContestAPIManager?
    var contestDetail: [ContestModel]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    var checkCaller: CheckRegisteredAPIManager?
    var index: Int = 0
    
    @IBAction func playerContest(_ sender: Any) {
        if let registeredViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RegisteredContestViewController") as? RegisteredContestViewController{
            navigationController?.pushViewController(registeredViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomViewCell()
        staticQuizCollectionView.delegate = self
        staticQuizCollectionView.dataSource = self
        urlCaller = StaticContestAPIManager()
        checkCaller = CheckRegisteredAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchContestList()
        checkCaller?.delegate = self
        playerContest.layer.cornerRadius = 15.0
    }
    
    func updateData(contestDetail: [ContestModel]){
        self.contestDetail = contestDetail
        DispatchQueue.main.async {
            self.staticQuizCollectionView.reloadData()
        }
    }
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateData(checkDetail: Bool) {
        hasRegistered = checkDetail
        DispatchQueue.main.async {
            if self.hasRegistered == true{
                self.registerUser()
            }
            else{
                self.displayAlert(title: "Registration Alert", message: "You had already Registered")
            }
        }
    }
    
    func registerUser(){
        guard let url = URL(string: "http://10.20.4.154:8180/subscription/post") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "contestId" : self.contestDetail?[index].id,
            "playerId" : UserDefaults.standard.string(forKey: "playerId")
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
                print("Success: \(response)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Register Alert", message: "Successfully Registered", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func registerCustomViewCell(){
        let nib = UINib(nibName: "StaticContestCollectionViewCell", bundle: nil)
        staticQuizCollectionView.register(nib, forCellWithReuseIdentifier: "StaticContestCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contestDetail?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = staticQuizCollectionView.dequeueReusableCell(withReuseIdentifier: "StaticContestCollectionViewCell", for: indexPath) as? StaticContestCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        cell.quizName.text = contestDetail?[indexPath.row].contestName
        cell.category.text = contestDetail?[indexPath.row].category
        if let contestDetail = contestDetail, let duration = contestDetail[indexPath.row].duration{
            cell.duration.text = "\(Int(duration)) mins"
        }
        cell.startTime.text = contestDetail?[indexPath.row].startTime
        cell.startDate.text = contestDetail?[indexPath.row].startDate
        cell.playQuizHandler = {[weak self] in
            self?.index = indexPath.row
            self?.checkCaller?.fetchContestList(contestId: self?.contestDetail?[indexPath.row].id ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width - 32.0, height: 200)
        return cellSize
    }
}
