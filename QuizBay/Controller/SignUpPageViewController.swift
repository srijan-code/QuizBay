//
//  SignUpPageViewController.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 09/08/22.
//

import UIKit

class SignUpPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        if let giveDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginPageViewController") as? LoginPageViewController{
            self.navigationController?.pushViewController(giveDetails, animated: true)
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let checkEmail: Bool = validEmail()
        let fieldsCheck: Bool = allFieldsAreFilled()
        let numberCheck: Bool = validPhoneNumber()
        if fieldsCheck == true {
            if checkEmail == true && numberCheck == true{
                registerCustomer()
            }
            else {
                if numberCheck == false {
                    displayAlert(title: "SignUp Alert", message: "Phone Number Must Be In Range [0-9]")
                }
                else
                {
                    displayAlert(title: "SignUp Alert", message: "Invalid Email")
                }
            }
        }
        else {
            displayAlert(title: "SignUp Alert", message: "Please Fill All Fields")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        genderField.delegate = self
        phoneField.delegate = self
        usernameField.delegate = self
        self.passwordField.isSecureTextEntry = true
        signUpButton.layer.cornerRadius = 20.0
    }
    
    func allFieldsAreFilled() -> Bool{
        if (emailField.text != "") && (passwordField.text != "") && (usernameField.text != "") && (phoneField.text != "") && (genderField.text != ""){
            return true
        }
        return false
    }
    
    func validEmail() -> Bool{
        var countAtRate: Int = 0
        var charsAfter: Int = 0
        if let text = emailField.text{
            if text.count <= 6{
                return false
            }
            for item in text{
                if countAtRate >= 1{
                    charsAfter = charsAfter + 1
                }
                if item == "@"
                {
                    countAtRate = countAtRate + 1
                }
            }
            let domain = text.suffix(4)
            if domain != ".com" {
                print("mail: returned")
                return false
            }
        }
        return countAtRate == 1 && charsAfter > 4
    }
    
    func displayAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validPhoneNumber() ->Bool {
        if let phone = phoneField.text{
            for item in phone{
                if item < "0" || item > "9"
                {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func registerCustomer(){
        guard let url = URL(string: "http://10.20.4.154:8180/auth/signup") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "password": passwordField.text,
            "gender": genderField.text,
            "name": usernameField.text,
            "email": emailField.text,
            "mobile": phoneField.text
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
                print("Success: \(response)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "SignUp Alert", message: "Successfully Registered, Kindly Login!!!!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
    }
}
