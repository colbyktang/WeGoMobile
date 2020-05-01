//
//  ConfirmationViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/30/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit
import MapKit

class ConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let party_size = defaults.string(forKey: "party_size")!
        let order_id = defaults.string(forKey:"order_id")!
        let eta = defaults.string(forKey:"eta")!
        let vehicleType = defaults.string(forKey:"vehicle_type")!
        txt_orderID.text = "Order ID: \(order_id)"
        txt_eta.text = "ETA: \(eta) minutes"
        txt_vehicleType.text = "Vehicle Type: \(vehicleType)"
        txt_partySize.text = "Party Size: \(party_size)"
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var txt_orderID: UILabel!
    @IBOutlet weak var txt_eta: UILabel!
    @IBOutlet weak var txt_vehicleType: UILabel!
    @IBOutlet weak var txt_partySize: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
