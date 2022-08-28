//
//  LeaderBoardViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class LeaderBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LeaderBoardAPIManagerDelegate {
    
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var point1: UILabel!
    @IBOutlet weak var point2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var point3: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var rankDisplayCollectionView: UICollectionView!
    
    var displayLeaderboard: [String:Int]?
    var urlCaller: LeaderBoardAPIManager?
    var leaderBoardDetail: [LeaderBoard]?
    let interItemSpacing: CGFloat = 16.0
    let lineSpacing: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomViewCell()
        rankDisplayCollectionView.delegate = self
        rankDisplayCollectionView.dataSource = self
        urlCaller = LeaderBoardAPIManager()
        urlCaller?.delegate = self
        urlCaller?.fetchLeaderboardData()
    }
    
    func updateData(leaderBoardDetail: [LeaderBoard]) {
        self.leaderBoardDetail = leaderBoardDetail
        DispatchQueue.main.async {
            self.rankDisplayCollectionView.reloadData()
        }
    }
    
    func updateBoard(){
        if let leaderBoardDetail = leaderBoardDetail{
            for item in leaderBoardDetail{
                if let name = item.name, let score = item.score{
                    displayLeaderboard?[name] = displayLeaderboard?[name] ?? 0  + score
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaderBoardDetail?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = rankDisplayCollectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCollectionViewCell", for: indexPath) as? LeaderboardCollectionViewCell else{
            print("custom cell not being created")
            return UICollectionViewCell()
        }
        if indexPath.row == 0{
            player1.text = leaderBoardDetail?[indexPath.row].name
            if let detail = leaderBoardDetail, let score = detail[indexPath.row].score{
                point1.text = "\(score)"
            }
            if let detail = leaderBoardDetail, let timeTaken = detail[indexPath.row].timeTaken{
                var seconds = Int(timeTaken * 60)
                let minutes = Int((seconds)/60)
                seconds = seconds % 60
                time1.text = "\(Int(minutes)):\(Int(seconds))"
            }
        }
        if indexPath.row == 1{
            player2.text = leaderBoardDetail?[indexPath.row].name
            if let detail = leaderBoardDetail, let score = detail[indexPath.row].score{
                point2.text = "\(score)"
            }
            if let detail = leaderBoardDetail, let timeTaken = detail[indexPath.row].timeTaken{
                var seconds = Int(timeTaken * 60)
                let minutes = Int((seconds)/60)
                seconds = seconds % 60
                time2.text = "\(Int(minutes)):\(Int(seconds))"
            }
        }
        if indexPath.row == 2{
            player3.text = leaderBoardDetail?[indexPath.row].name
            if let detail = leaderBoardDetail, let score = detail[indexPath.row].score{
                point3.text = "\(score)"
            }
            if let detail = leaderBoardDetail, let timeTaken = detail[indexPath.row].timeTaken{
                var seconds = Int(timeTaken * 60)
                let minutes = Int((seconds)/60)
                seconds = seconds % 60
                time3.text = "\(Int(minutes)):\(Int(seconds))"
            }
        }
        cell.playerName.text = leaderBoardDetail?[indexPath.row].name
        if let detail = leaderBoardDetail, let score = detail[indexPath.row].score{
            cell.points.text = "\(score)"
        }
        if let detail = leaderBoardDetail, let timeTaken = detail[indexPath.row].timeTaken{
            var seconds = Int(timeTaken * 60)
            let minutes = Int((seconds)/60)
            seconds = seconds % 60
            cell.timeTaken.text = "\(Int(minutes)):\(Int(seconds))"
        }
        cell.layer.cornerRadius = 15.0
        cell.rank.text = "\(indexPath.row + 1)"
        cell.backgroundColor = UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:UIScreen.main.bounds.width - 32.0, height: 50)
        return cellSize
    }
    
    func registerCustomViewCell(){
        let nib = UINib(nibName: "LeaderboardCollectionViewCell", bundle: nil)
        rankDisplayCollectionView.register(nib, forCellWithReuseIdentifier: "LeaderboardCollectionViewCell")
    }
}
