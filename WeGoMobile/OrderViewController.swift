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

class OrderViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
      CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           //print(currentLoc.coordinate.latitude)
           //print(currentLoc.coordinate.longitude)
        }
        // Do any additional setup after loading the view.
    }
    
    // hiding the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var txt_location: UITextField!
    @IBOutlet weak var segmented_partySize: UISegmentedControl!
    @IBAction func btn_submit(_ sender: UIButton) {
        if (txt_location.text! == "") {
            return
        }
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey:"username")
        let partySize = segmented_partySize.titleForSegment(at: segmented_partySize.selectedSegmentIndex)
        defaults.set(partySize, forKey:"party_size")
        
        let params = ["stops": [txt_location.text!, "3001 S Congress Avenue, Austin, TX"], "size": partySize, "vehicle_type": "VAN", "username": username] as [String : Any]
        POSTRequest (server: "demand", endpoint: "api/backend/order", params: params)
    }
    
    func POSTRequest (server: String, endpoint: String, params: Dictionary<String, Any?>) {
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
            guard let eta = serverResponse["eta"] as? Int else {
                print("Could not get eta as Int from JSON")
                return
            }
            print("The ETA is: \(eta)")
            
            guard let order_id = serverResponse["order_id"] as? String else {
                print("Could not get order_id as String from JSON")
                return
            }
            print("The Order_ID is: \(order_id)")
            
            guard let vehicle_type = serverResponse["vehicle_type"] as? String else {
                print("Could not get vehicle_type as String from JSON")
                return
            }
            print("The vehicle_type is: \(vehicle_type)")
            
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        let defaults = UserDefaults.standard
                        defaults.set(eta, forKey:"eta")
                        defaults.set(order_id, forKey:"order_id")
                        defaults.set(vehicle_type, forKey:"vehicle_type")
                        self.performSegue(withIdentifier: "segue_successOrder", sender: self)
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
