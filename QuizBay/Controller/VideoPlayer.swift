//
//  VideoPlayer.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 06/08/22.
//

import UIKit
import AVKit

class VideoPlayer: UIView {

    @IBOutlet weak var vwPlayer: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    var player: AVPlayer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    fileprivate func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        addPlayerToView(self.vwPlayer)
    }
    
    fileprivate func addPlayerToView(_ view: UIView){
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay) , name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func playVideoWithFileName(_ fileName: String, ofType type: String){
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else {
            return
        }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    @objc func playerEndPlay(){
        print("Player ends Playing Video")
    }

}
