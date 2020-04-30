//
//  DashboardViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/30/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit

class DashboardViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let first_name = defaults.string(forKey:"first_name")
        let last_name = defaults.string(forKey:"last_name")
        
        lbl_welcome.text = "Welcome \(first_name!) \(last_name!)!"
    }
    
    @IBOutlet weak var lbl_welcome: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
