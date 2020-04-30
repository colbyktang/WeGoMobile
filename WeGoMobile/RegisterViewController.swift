//
//  RegisterViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/29/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit

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
        
        if (txt_password.text == "") {
            createAlert (title: "WeGo Registration", message: "First name cannot be blank!")
            return
        }
        
        if (txt_password.text != txt_confirmPassword.text) {
            createAlert(title: "WeGo Registration", message: "Passwords do not match!")
        }

        if (txt_email.text == "") {
            createAlert(title: "WeGo Registration", message: "Email cannot be blank!")
        }
        
        if (txt_phoneNumber.text == "") {
            createAlert(title: "WeGo Registration", message: "Phone Number cannot be blank!")
        }
    }
    
    func createAlert (title: String, message: String) {
        print ("Create Alert: Title: \(title) Message: \(message)")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
