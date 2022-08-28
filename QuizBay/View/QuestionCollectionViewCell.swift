//
//  QuestionCollectionViewCell.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 05/08/22.
//

import UIKit
import AVKit

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option2: UIButton!
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    @IBAction func option2(_ sender: Any) {
    }
    
    @IBAction func option3(_ sender: Any) {
    }
    
    @IBAction func option1(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        option3.layer.cornerRadius = 10.0
        option1.layer.cornerRadius = 10.0
        option2.layer.cornerRadius = 10.0
    }
    
}
