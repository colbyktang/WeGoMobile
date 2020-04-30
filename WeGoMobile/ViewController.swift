//
//  ViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/29/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "logged_in") == true {
            self.performSegue(withIdentifier: "segue_successLogin", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    // hiding the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btn_SignIn(_ sender: UIButton) {
        if (txt_Username.text == "") {
            createAlert(title: "Error", message: "Username is blank!")
            return
        }
        
        if (txt_Password.text == "") {
            createAlert(title: "Error", message: "Password is blank!")
            return
        }
        
        let params = ["username":txt_Username.text, "password":txt_Password.text]
        POSTRequest(server: "demand", endpoint: "api/cs/login", params: params)
    }
    
    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    
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
            guard let responseData = data else {
                print("Error: did not receive data")
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: "Error: did not receive data")
                }
                return
            }

        // parse the result as JSON, since that's what the API provides
        do {
            guard let serverResponse = try JSONSerialization.jsonObject(with: responseData,
                options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
            }
            print("The server response is: " + serverResponse.description)
            guard let first_name = serverResponse["first_name"] as? String else {
                print("Could not get first_name as String from JSON")
                return
            }
            print("The First Name is: \(first_name)")
            
            guard let last_name = serverResponse["last_name"] as? String else {
                print("Could not get last_name as String from JSON")
                return
            }
            print("The Last Name is: \(last_name)")
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        let defaults = UserDefaults.standard
                        defaults.set(params["username"]!, forKey:"username")
                        defaults.set(first_name, forKey:"first_name")
                        defaults.set(last_name, forKey:"last_name")
                        defaults.set(true, forKey:"logged_in")
                        
                        self.performSegue(withIdentifier: "segue_successLogin", sender: self)
                    }
                }
            }
        } catch  {
            if let stringResponse = String(data: data!, encoding: String.Encoding.utf8) as String? {
                print (stringResponse)
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: stringResponse)
                }
            }
            else {
                print("Error parsing response from POST on /serverResponse")
                DispatchQueue.main.async {
                    self.createAlert (title: "Response from Server", message: "Error parsing response from POST on /serverResponse")
                }
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

