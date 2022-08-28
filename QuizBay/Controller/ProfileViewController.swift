//
//  ProfileViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class ProfileViewController: UIViewController, UserAPIManagerDelegate {
    
    @IBOutlet weak var playerLevel: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportImage: UIImageView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var winsStatic: UILabel!
    @IBOutlet weak var rightAnswerStatic: UILabel!
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var winImage: UIImageView!
    @IBOutlet weak var gamesStatic: UILabel!
    @IBOutlet weak var rightAnswersCount: UILabel!
    @IBOutlet weak var totalWinsCount: UILabel!
    @IBOutlet weak var totalGameCount: UILabel!
    @IBOutlet weak var totalRightAnswerView: UIView!
    @IBOutlet weak var totalWinView: UIView!
    @IBOutlet weak var totalGameView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var profileDisplay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileDisplay()
        setReportView()
        setViews(display: totalWinView)
        setViews(display: totalRightAnswerView)
        setViews(display: totalGameView)
        urlCaller = UserAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchUserData(mailId: UserDefaults.standard.string(forKey: "userEmail") ?? "abcd@gmail.com")
    }
    
    var userData: User?
    var urlCaller: UserAPIManager?
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportButton(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        urlCaller?.fetchUserData(mailId: UserDefaults.standard.string(forKey: "userEmail") ?? "abcd@gmail.com")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setImageForViews(avatar: avatarImage, height: 50.0, fileName: "user_male")
        setImageForViews(avatar: gameImage, height: 30.0, fileName: "brain_icon")
        setImageForViews(avatar: answerImage, height: 30.0, fileName: "question_icon")
        setImageForViews(avatar: winImage, height: 30.0, fileName: "trophy_icon")
        setImageForViews(avatar: reportImage, height: 25.0, fileName: "report_vector")
    }
    
    func updateData(userDetail: User) {
        userData = userDetail
        DispatchQueue.main.async {
            self.updateProfile()
            UserDefaults.standard.setValue(self.userData?.id, forKey: "playerId")
        }
    }
    
    func updateProfile(){
        playerName.text = userData?.name
        if let userData = userData, let rating = userData.userLevelRating{
            playerLevel.text = "\(rating)"
        }
        if let userData = userData, let score = userData.totalScore{
            totalWinsCount.text = "\(score)"
        }
    }
    
    func setReportView(){
        reportView.clipsToBounds = true
        reportView.layer.cornerRadius = 20
    }
    
    func setProfileDisplay(){
        profileDisplay.layer.cornerRadius = 20
        profileDisplay.backgroundColor =  UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func setViews(display: UIView){
        display.layer.cornerRadius = 10;
        display.layer.masksToBounds = true
        display.layer.shadowColor = UIColor.gray.cgColor
        display.layer.shadowOpacity = 0.8
        display.layer.shadowOffset = CGSize.zero
        display.layer.shadowRadius = 6
        display.layer.borderWidth = 2
        display.layer.borderColor = UIColor.white.cgColor
    }
    
    func setImageForViews(avatar: UIImageView,height: CGFloat, fileName: String)
    {
        avatar.layer.masksToBounds = false;
        avatar.clipsToBounds = true;
        avatar.layer.cornerRadius = height
        avatar.image = UIImage(named: fileName)
    }
}
