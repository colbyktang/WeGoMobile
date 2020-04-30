//
//  RegisterViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/29/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmPassword: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_phoneNumber: UITextField!
    
    // hiding the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btn_Register(_ sender: UIButton) {
        if (txt_firstName.text == "") {
            createAlert (title: "WeGo Registration", message: "First name cannot be blank!")
            return
        }
        
        if (txt_lastName.text == "") {
            createAlert (title: "WeGo Registration", message: "Last name cannot be blank!")
            return
        }
        
        if (txt_username.text == "") {
            createAlert (title: "WeGo Registration", message: "Username cannot be blank!")
            return
        }
        
        if (txt_username.text!.count < 5) {
            createAlert (title: "WeGo Registration", message: "Username cannot be less than 5 characters!")
            return
        }
        
        if (txt_password.text == "") {
            createAlert (title: "WeGo Registration", message: "Password cannot be blank!")
            return
        }
        
        if (txt_password.text != txt_confirmPassword.text) {
            createAlert(title: "WeGo Registration", message: "Passwords do not match!")
            return
        }
        
        if (txt_password.text!.count < 6) {
            createAlert(title: "WeGo Registration", message: "Password cannot be less than 6 characters!")
            return
        }

        if (txt_email.text == "") {
            createAlert(title: "WeGo Registration", message: "Email cannot be blank!")
            return
        }
        
        let email = txt_email.text
        let range = NSRange(location: 0, length: email!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$")
        let isEmailValid = regex.firstMatch(in: email!, options: [], range: range) != nil
        
        if (!isEmailValid) {
            createAlert(title: "WeGo Registration", message: "Email is not valid!")
            return
        }
        
        if (txt_phoneNumber.text == "") {
            createAlert(title: "WeGo Registration", message: "Phone Number cannot be blank!")
            return
        }
        
        if (txt_phoneNumber.text!.count != 10) {
            createAlert(title: "WeGo Registration", message: "Phone Number must have 10 digits!")
            return
        }
        
        if (!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: txt_phoneNumber.text!))) {
            createAlert(title: "WeGo Registration", message: "Phone Number consist of digits!")
            return
        }
        
        let register_dictionary = [
            "first_name": txt_firstName.text!,
            "last_name": txt_lastName.text!,
            "username": txt_username.text!,
            "password": txt_password.text!,
            "email": txt_email.text!,
            "phone_number": txt_phoneNumber.text!
        ]
        
        POSTRequest(server: "demand", endpoint: "api/cs/register", params: register_dictionary)
    }
    
    func POSTRequest (server: String, endpoint: String, params: Dictionary<String, String?>) {
        print ("server: \(server) endpoint: \(endpoint) params: \(params)")
        var request = URLRequest(url: URL(string: "https://\(server).team12.softwareengineeringii.com/\(endpoint)")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /request/1")
                print(error!)
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: "error calling POST on /request/1")
                }
                return
            }
            guard data != nil else {
                print("Error: did not receive data")
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: "Error: did not receive data")
                }
                return
            }

        do {
            if let stringResponse = String(data: data!, encoding: String.Encoding.utf8) as String? {
                print (stringResponse)
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: stringResponse)
                }
            }
            else {
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        let defaults = UserDefaults.standard
                        defaults.set(params["username"]!, forKey:"username")
                        defaults.set(params["first_name"]!, forKey:"first_name")
                        defaults.set(params["last_name"]!, forKey:"last_name")
                        defaults.set(true, forKey:"logged_in")
                        
                        self.performSegue(withIdentifier: "segue_onregister", sender: self)
                    }
                }
            }
        } catch  {

            print("Error parsing response from POST on /serverResponse")
            DispatchQueue.main.async {
                self.createAlert (title: "Response from Server", message: "Error parsing response from POST on /serverResponse")
            }
            return
        }
      }

        task.resume()
    }

    
    func createAlert (title: String, message: String) {
        print ("Create Alert: Title: \(title) Message: \(message)")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
