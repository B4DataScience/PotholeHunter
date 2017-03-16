//
//  PhotoViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoViewController: UIViewController,CLLocationManagerDelegate {
    //MARK: Properties
    var potholePhoto:UIImage?
    var latitude:Double?
    var longitude:Double?
    var date:Date?
    var location: CLLocation?
    var severity:Int?
    let locationManager = CLLocationManager()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var capturedOn: UILabel!
    @IBOutlet weak var locatedAt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = potholePhoto{
            imageView.image = image
        }
        else{
            print("coudnt aquire photo from showcameraViewController")
        }
        severity = 5
        let dateFormattor = DateFormatter()
        dateFormattor.timeStyle = .none
        dateFormattor.dateStyle = .medium
        capturedOn.text = "Captured on: " + dateFormattor.string(from: date!)
        assignAddress()
        
    }
    
    func assignAddress(){
        locationManager.delegate = self
        CLGeocoder().reverseGeocodeLocation(location!) { (placemark, error) in
            if error != nil{
                print ("Error in revergeocoding")
            }
            else{
                if let place = placemark?[0]
                {
                    if let street = place.subThoroughfare{
                        self.locatedAt.text = "Location: \(street), \(place.thoroughfare!), \(place.locality!)."
                    }
                    else{
                        self.locatedAt.text = "Location: \(place.thoroughfare!), \(place.locality!)."
                    }
                    
                }
            }
        }
    }
    @IBAction func pickingSeverity(_ sender: UISlider) {
        severity = Int(sender.value)
        if(severity! <= 4 ){
            sender.tintColor = .yellow
            sender.thumbTintColor = .yellow
        }
        else if(severity! < 8 ){
            sender.tintColor = .blue
            sender.thumbTintColor = .blue
        }
        else{
            sender.tintColor = .red
            sender.thumbTintColor = .red
        }
    }

    @IBAction func report(_ sender: UIButton) {
        let pothole = Pothole()
        pothole.potholeImage = self.potholePhoto
        pothole.address = self.locatedAt.text
        pothole.capturedOn = self.date
        pothole.severity = self.severity
        pothole.pLocation = self.location
        PotholeData.potholes.append(pothole)
        performSegue(withIdentifier: "SayThankYou", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
