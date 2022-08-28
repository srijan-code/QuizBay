//
//  StaticPlayCollectionViewCell.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 08/08/22.
//

import UIKit




class StaticPlayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var quizCategory: UILabel!
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
