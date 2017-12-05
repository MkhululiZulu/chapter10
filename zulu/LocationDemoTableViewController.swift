//
//  LocationDemoTableViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 11/28/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDemoTableViewController: UITableViewController, CLLocationManagerDelegate
    {
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblHeadingAccuracy: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblAltitudeAccuracy: UILabel!
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!
    
    
    
    @IBOutlet weak var lblLocationAccuracy: UILabel!
    
    func dismissKeyBoard(){
    //causes the view (or one of its embedded text fields) to resign the first responder status 
    view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var locationManager: CLLocationManager!

        let tap: UITapGestureRecognizer
            = UITapGestureRecognizer(target: self ,
        action: #selector(self.dismissKeyBoard))
        
        
        
    view.addGestureRecognizer(tap)
        // sey up location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //ask for permission to use location 
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
        {
            if status == .authorizedWhenInUse{
            print("Permission granted ")
            }
            else {
            print("Permission NOT granted")
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func deviceCoordinates(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func addressToCoordinates(_ sender: Any) {
    
        let address = "\(txtStreet.text!), \(txtCity.text!), \(txtState.text!))"
        geoCoder.geocodeAddressString(address){(placemarks, error ) in self.processAddressResponse(withPlacemarks: placemarks, error: error )
        
        }
    }
    
    private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?)
    
    {
        if let error = error {
        print ("Geocode Error: \(error)")
        }
        else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
            bestMatch = placemarks.first?.location
            }
            if let coordinate = bestMatch?.coordinate
            {
                lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
                lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
                
            }
            else {
            print("Didnt find any matching locations ")
            
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
        let eventDate = location.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
            if Double(howRecent) < 15.0{
        let coordinate = location.coordinate
            lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
            lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
            lblLocationAccuracy.text = String(format: "%gm", location.horizontalAccuracy)
                lblAltitude.text = String(format: "%gm", location.altitude)
                lblAltitudeAccuracy.text = String(format: "%gm", location.verticalAccuracy)
        }
    
    }
        
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
            if newHeading.headingAccuracy > 0{
                let theHeading = newHeading.trueHeading
                var direction: String
                switch theHeading {
                case 225..<315:
                direction = "W"
                case 135..<225:
                direction = "S"
                case 45..<135:
                direction = "E"
                default:
                direction = "N"
                }
                lblHeading.text = String(format: "&g\u{00B0}, (%0)", theHeading, direction)
                lblHeadingAccuracy.text = String(format: "&g\u{00B0}, (%0)", newHeading.headingAccuracy)
                
                
            }
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError: Error)
        {
            let errorType = error._code == CLError.denied.rawValue ? "Location Permission Denied" : "Unknown Error"
            let alertController = UIAlertController(title: "Error Getting Location: \(errorType)", message: "Error Message: \(error.localizedDescription))", preferredStyle: .alert)
            let alertOK = UIAlertAction(title: "OK", style: .default, handler: nil )
            alertController.addAction(actionOK)
            present(alertController, animated: true, completion: nil)
            
            
        }
        
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
