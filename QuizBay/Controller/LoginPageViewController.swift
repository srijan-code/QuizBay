//
//  ViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 03/08/22.
//

import UIKit

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameLabel: UITextField!{
        didSet {
            userNameLabel.tintColor = UIColor.lightGray
            userNameLabel.setIcon(UIImage(named: "at_icon")!)
        }
    }
    @IBOutlet weak var passwordLabel: UITextField!{
        didSet {
            passwordLabel.tintColor = UIColor.lightGray
            passwordLabel.setIcon(UIImage(named: "lock_icon")!)
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpPageViewController") as? SignUpPageViewController{
            self.navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        logInUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelBorder()
        passwordLabel.isSecureTextEntry = true
    }
    
    func moveToHome(){
        if let homePageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomePageViewController") as? HomePageViewController{
            navigationController?.pushViewController(homePageViewController, animated: true)
        }
    }
    
    func logInUser(){
        guard let url = URL(string: "http://10.20.3.120:8111/user/login") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "email": userNameLabel.text,
            "password": passwordLabel.text,
            "socialMediaId": 4
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, httpresponse, error in
            guard let data = data,error == nil else{
                return
            }
            guard let httpResponseRecv = httpresponse as? HTTPURLResponse else {
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Success: \(response)")
                if let token = httpResponseRecv.allHeaderFields["token"]{
                    print("Token: \(token)")
                    DispatchQueue.main.async {
                        UserDefaults.standard.setValue(httpResponseRecv.allHeaderFields["token"],forKey: "token")
                        UserDefaults.standard.setValue(self.userNameLabel.text, forKey: "userEmail" )
                        self.moveToHome()
                    }
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func setLabelBorder(){
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: userNameLabel.frame.height - 1, width: userNameLabel.frame.width-42.0, height: 2.0)
        bottomLine1.backgroundColor = UIColor.systemGray2.cgColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: passwordLabel.frame.height - 1, width: passwordLabel.frame.width-42.0, height: 2.0)
        bottomLine2.backgroundColor = UIColor.systemGray2.cgColor
        userNameLabel.borderStyle = .none
        userNameLabel.layer.addSublayer(bottomLine1)
        passwordLabel.borderStyle = .none
        passwordLabel.layer.addSublayer(bottomLine2)
    }
}

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

