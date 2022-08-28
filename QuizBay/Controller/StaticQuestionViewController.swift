//
//  StaticQuestionViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 05/08/22.
//

import UIKit
import AVKit

class StaticQuestionViewController: UIViewController, StaticQuestionManagerDelegate, AdsManagerDelegate {
    
    @IBOutlet weak var adsImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var staticView: UIView!
    @IBOutlet weak var questionStats: UILabel!
    @IBOutlet weak var QuestionView: UIView!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var skipLabel: UILabel!
    
    var adsData: AdsModel?
    var adsCaller: AdsManager?
    var currentIndex: Int = 0
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var urlCaller: StaticQuestionAPIManager?
    var questionDetail: Question?
    var maximumQuestions: Int? = 0
    var isLast: Bool? = false
    var questionId: [String]?
    var result = [String: String]()
    var optionTapped:String?
    var skipsAllowed: Int = 0
    var isTapped:Bool = false
    var contestId: String?
    var countDown: Int = 1800
    var durationTime: Int = 0
    var timer:Timer?
    
    @IBAction func skipButton(_ sender: Any) {
        
        if skipsAllowed == 0
        {
            let alert = UIAlertController(title: "Skip Alert", message: "Skips Limit Reached", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if isLast == false{
                uploadNextQuestion()
                skipsAllowed = skipsAllowed - 1
            } else {
                sendAnswers()
                displayAlert(title: "Thank You!!!!", message: "Check LeaderBoard For Ranking")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        skipLabel.text = "Skips Left: \(skipsAllowed)"
        resetButton()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        displayAds()
        
    }
    
    @IBAction func option1(_ sender: Any) {
        option1.layer.backgroundColor = UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        option2.layer.backgroundColor = UIColor.systemGray5.cgColor
        option3.layer.backgroundColor = UIColor.systemGray5.cgColor
        result[questionId?[currentIndex-1] ?? ""] = option1.titleLabel?.text
        isTapped = true
    }
    
    @IBAction func option2(_ sender: Any) {
        option1.layer.backgroundColor = UIColor.systemGray5.cgColor
        option2.layer.backgroundColor = UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        option3.layer.backgroundColor = UIColor.systemGray5.cgColor
        result[questionId?[currentIndex-1] ?? ""] = option2.titleLabel?.text
        isTapped = true
    }
    
    @IBAction func option3(_ sender: Any) {
        option1.layer.backgroundColor = UIColor.systemGray5.cgColor
        option2.layer.backgroundColor = UIColor.systemGray5.cgColor
        option3.layer.backgroundColor = UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        result[questionId?[currentIndex-1] ?? ""] = option3.titleLabel?.text
        isTapped = true
    }
    
    func updateAds(AdsDetail: AdsModel) {
        adsData = AdsDetail
        DispatchQueue.main.async{
            self.adsImage.isHidden = false
            self.loadImage(urlString: self.adsData?.image, imageView: self.adsImage)
            self.questionUpdate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.adsImage.isHidden = true
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDownMethod), userInfo: nil, repeats: true)
                self.updateTimer(duration: self.countDown)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsImage.isHidden = true
        setPlayerText()
        setButton()
        urlCaller = StaticQuestionAPIManager()
        urlCaller?.delegate = self
        adsCaller = AdsManager()
        adsCaller?.delegate = self
        if isLast == false{
            uploadNextQuestion()
        }
        setStaticDisplay()
        skipLabel.text = "Skips Left: \(skipsAllowed)"
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
        updateTimer(duration: countDown)
    }
    
    func questionUpdate(){
        if isTapped == false{
            let alert = UIAlertController(title: "Alert", message: "Either press skip button or tap any answer", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isLast == false{
            uploadNextQuestion()
            isTapped = false
        } else
        {
            sendAnswers()
            displayAlert(title: "Thank You!!!!", message: "Check LeaderBoard For Ranking")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        resetButton()
        
    }
    func sendAnswers(){
        guard let url = URL(string: "http://10.20.4.154:8181/evaluate") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "contestId": contestId,
            "results" : result,
            "playerId" : UserDefaults.standard.string(forKey: "playerId"),
            "timeTaken": "\(Double(durationTime-countDown)/60)",
            "type": "static"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, httpresponse, error in
            guard let data = data,error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Success: \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func setStaticDisplay(){
        staticView.clipsToBounds = true
        staticView.layer.cornerRadius = 20
        staticView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        staticView.layer.masksToBounds = true;
        staticView.backgroundColor =  UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func uploadNextQuestion(){
        urlCaller?.fetchQuestionList(questionId: questionId?[currentIndex] ?? "")
    }
    
    func updateData(questionDetail: Question) {
        self.questionDetail = questionDetail
        DispatchQueue.main.async {
            if questionDetail.questionFormat == "Video"
            {
                self.player.pause()
                self.QuestionView.isHidden = false
                self.imageView.isHidden  = true
                self.setPlayer(url: questionDetail.url ?? "")
            }
             else if questionDetail.questionFormat == "Audio"{
                self.QuestionView.isHidden = false
                self.imageView.isHidden = true
                self.setPlayer(url: questionDetail.url ?? "")
            } else if questionDetail.questionFormat == "Image"{
                self.imageView.isHidden = false
                self.QuestionView.isHidden = true
                self.loadImage(urlString: questionDetail.url, imageView: self.imageView)
            } else {
                self.imageView.isHidden = true
                self.QuestionView.isHidden = false
                self.setPlayerText()
            }
            self.questionLabel.text = self.questionDetail?.question
            self.option1.setTitle(self.questionDetail?.answerList?[0].value, for: .normal)
            self.option2.setTitle(self.questionDetail?.answerList?[1].value, for: .normal)
            self.option3.setTitle(self.questionDetail?.answerList?[2].value, for: .normal)
            self.currentIndex = self.currentIndex + 1
            if self.currentIndex == self.maximumQuestions ?? 0
            {
                self.isLast = true
                self.nextButton.setTitle("Submit", for: .normal)
            }
            if let maximumQuestions = self.maximumQuestions{
                self.questionStats.text = "question \(self.currentIndex) of \(maximumQuestions)"
            }
        }
    }
    
    func resetButton(){
        option1.layer.backgroundColor = UIColor.systemGray5.cgColor
        option2.layer.backgroundColor = UIColor.systemGray5.cgColor
        option3.layer.backgroundColor = UIColor.systemGray5.cgColor
    }
    
    func setPlayer(url: String){
        let videoURL = URL(string:url)
        self.player = AVPlayer(url: videoURL!)
        self.playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.view.frame = QuestionView.bounds
        playerViewController.player?.pause()
        QuestionView.addSubview(playerViewController.view)
    }
    
    func setPlayerText()
    {
        let videoURL = Bundle.main.url(forResource: "robot_mp4", withExtension: "mp4")
        self.player = AVPlayer(url: videoURL!)
        self.playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.view.frame = QuestionView.bounds
        playerViewController.player?.pause()
        playerViewController.showsPlaybackControls = false
        QuestionView.addSubview(playerViewController.view)
        QuestionView.backgroundColor = UIColor.white
        player.play()
    }
    
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    
    func displayAds(){
        adsCaller?.fetchAdsList(searchItem: "")
    }
   
    func updateTimer(duration: Int){
        let minutes = (duration/60)
        let seconds = (duration%60)
        if minutes>9 && seconds>9{
            timerLabel.text = "\(minutes):\(seconds)"
        } else if minutes<=9 && seconds>9{
            timerLabel.text = "0\(minutes):\(seconds)"
        }
        else if minutes>9 && seconds<=9{
            timerLabel.text = "\(minutes):0\(seconds)"
        }else if minutes<=9 && seconds<=9{
            timerLabel.textColor = UIColor.red
            timerLabel.text = "0\(minutes):0\(seconds)"
        }
    }
    
    @objc func countDownMethod(){
        countDown = countDown - 1
        updateTimer(duration: countDown)
        if countDown == 0{
            timer?.invalidate()
            sendAnswers()
            displayAlert(title: "Oops! Time is Up!!!", message: "Check LeaderBoard For Ranking")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setButton(){
        nextButton.layer.cornerRadius = 10.0
        option1.layer.cornerRadius = 10.0
        option2.layer.cornerRadius = 10.0
        option3.layer.cornerRadius = 10.0
    }
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadImage(urlString: String?, imageView: UIImageView)  {
        if let unwrappedString = urlString,
           let url = URL(string: unwrappedString) {
            print(unwrappedString)
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    let loadedImage = UIImage(data: imageData)
                    imageView.image = loadedImage
                    imageView.contentMode = .scaleAspectFit
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
