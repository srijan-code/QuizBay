//
//  ContestTypeViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 04/08/22.
//

import UIKit

class ContestTypeViewController: UIViewController {
    
    @IBOutlet weak var dynamicQuizButton: UIButton!
    @IBOutlet weak var staticQuizButton: UIButton!
    
    @IBAction func dynamicQuizButton(_ sender: Any) {
        if let dynamicQuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DynamicQuizViewController") as? DynamicQuizViewController{
            navigationController?.pushViewController(dynamicQuizViewController, animated: true)
        }
    }
    
    @IBAction func staticQuizButton(_ sender: Any) {
        if let staticQuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StaticQuizViewController") as? StaticQuizViewController{
            navigationController?.pushViewController(staticQuizViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicQuizButton.layer.borderWidth = 1.0
        dynamicQuizButton.layer.borderColor =  UIColor(red: 71.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
    }
}
