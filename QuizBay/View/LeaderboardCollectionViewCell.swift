//
//  LeaderboardCollectionViewCell.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 07/08/22.
//

import UIKit

class LeaderboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var timeTaken: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
