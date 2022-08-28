//
//  StaticContestCollectionViewCell.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class StaticContestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var durationImage: UIImageView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var quizName: UILabel!
    
    var playQuizHandler: (() -> Void)?
    
    @IBAction func playButton(_ sender: Any) {
        playQuizHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.layer.cornerRadius = 5.0
    }
}
