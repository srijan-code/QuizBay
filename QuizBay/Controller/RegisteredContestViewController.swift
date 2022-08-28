//
//  RegisteredContestViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 09/08/22.
//

import UIKit

class RegisteredContestViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ValidationCheckManagerDelegate,RegisteredContestManagerDelegate {
    
    @IBOutlet weak var registeredQuizCollectionView: UICollectionView!
    
    var urlCaller: RegisteredContestAPIManager?
    var validCaller: ValidateContestAPIManager?
    var contestDetail: [Registration]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    var isReady: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomViewCell()
        registeredQuizCollectionView.delegate = self
        registeredQuizCollectionView.dataSource = self
        urlCaller = RegisteredContestAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchContestList()
        validCaller = ValidateContestAPIManager()
        validCaller?.delegate = self
        
    }
    
    func updateData(contestDetail: [Registration]){
        self.contestDetail = contestDetail
        DispatchQueue.main.async {
            self.registeredQuizCollectionView.reloadData()
        }
    }
    
    func updateData(isValid: Bool) {
        isReady = isValid
    }
    
    func registerCustomViewCell(){
        let nib = UINib(nibName: "StaticPlayCollectionViewCell", bundle: nil)
        registeredQuizCollectionView.register(nib, forCellWithReuseIdentifier: "StaticPlayCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contestDetail?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = registeredQuizCollectionView.dequeueReusableCell(withReuseIdentifier: "StaticPlayCollectionViewCell", for: indexPath) as? StaticPlayCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        cell.quizName.text = contestDetail?[indexPath.row].contest?.contestName
        if let contestDetail = contestDetail, let contest = contestDetail[indexPath.row].contest, let duration = contest.duration{
            cell.duration.text = "\(Int(duration)) mins"
        }
        cell.quizCategory.text = contestDetail?[indexPath.row].contest?.category
        cell.startTime.text = contestDetail?[indexPath.row].contest?.startTime
        cell.startDate.text = contestDetail?[indexPath.row].contest?.startDate
        cell.playQuizHandler = {[weak self] in
            DispatchQueue.global(qos: .background).async {
                // self?.validCaller?.fetchContestList(id: self?.contestDetail?[indexPath.row].contest?.id ?? "")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
                if self?.isReady == true{
                    if let staticQuestionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StaticQuestionViewController") as? StaticQuestionViewController{
                        staticQuestionViewController.questionId = self?.contestDetail?[indexPath.row].contest?.questionCode
                        staticQuestionViewController.maximumQuestions = self?.contestDetail?[indexPath.row].contest?.numberOfQuestions
                        staticQuestionViewController.skipsAllowed = self?.contestDetail?[indexPath.row].contest?.skipAllowed ?? 0
                        staticQuestionViewController.contestId = self?.contestDetail?[indexPath.row].contest?.id
                        staticQuestionViewController.countDown = (self?.contestDetail?[indexPath.row].contest?.duration ?? 0) * 60
                        staticQuestionViewController.durationTime = (self?.contestDetail?[indexPath.row].contest?.duration ?? 0) * 60
                        self?.navigationController?.pushViewController(staticQuestionViewController, animated: true)
                    }
                }else {
                    self?.displayAlert(title: "Quiz Alert", message: "Quiz Is Not Live For You")
                }
            }
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
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
