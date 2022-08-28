//
//  LaunchScreenViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 06/08/22.
//

import UIKit
import AVKit
import AVFoundation

class LaunchScreenViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupAVPlayer() {
        let videoURL = Bundle.main.url(forResource: "quizbay_logo_video", withExtension: "mp4")
        if let URL = videoURL{
            let avAssets = AVAsset(url: URL)
            let avPlayer = AVPlayer(url: URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
            self.view.layer.addSublayer(avPlayerLayer)
            avPlayer.play()
            avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
                if time == avAssets.duration {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            print("No file found")
        }
    }
}
