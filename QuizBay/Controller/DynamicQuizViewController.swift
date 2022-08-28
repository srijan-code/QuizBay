//
//  DynamicQuizViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class DynamicQuizViewController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageForViews(avatar: avatarImage, height: 20.0, fileName: "user_male")
        setNavigationDisplay()
    }
    
    func setNavigationDisplay(){
        navigationView.clipsToBounds = true
        navigationView.layer.cornerRadius = 20
        navigationView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        navigationView.layer.masksToBounds = true;
        navigationView.backgroundColor =  UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func setImageForViews(avatar: UIImageView,height: CGFloat, fileName: String)
    {
        avatar.layer.masksToBounds = false;
        avatar.clipsToBounds = true;
        avatar.layer.cornerRadius = height
        avatar.image = UIImage(named: fileName)
    }
}
