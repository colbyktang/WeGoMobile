//
//  OrderViewController.swift
//  WeGoMobile
//
//  Created by user169503 on 4/30/20.
//  Copyright © 2020 ctang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OrderViewController: UIViewController {
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
      CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           //print(currentLoc.coordinate.latitude)
           //print(currentLoc.coordinate.longitude)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
