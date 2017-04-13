//
//  PhotoViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class PhotoViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    //MARK: Properties
    var potholePhoto:UIImage?
    var latitude:Double?
    var longitude:Double?
    var date:String?
    var location: CLLocation?
    var severity:Int?
    var address:String?
    var additionalInfo:String?
    var pCount:Int?
    let locationManager = CLLocationManager()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var capturedOn: UILabel!
    @IBOutlet weak var locatedAt: UILabel!
    @IBOutlet weak var additionalInfoTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignAddress()
        activityIndicator.startAnimating()
        reportButton.isEnabled = false
        additionalInfoTextfield.delegate = self
        if let image = potholePhoto{
            imageView.image = image
        }
        else{
            print("coudnt aquire photo from showcameraViewController")
        }
        let roundPrecision:Double = 10000 //this will round the cordinates 
        self.latitude = Double(round((self.location?.coordinate.latitude)! * roundPrecision)/roundPrecision)
        self.longitude = Double(round((self.location?.coordinate.longitude)! * roundPrecision)/roundPrecision)
        severity = 5
        self.additionalInfo = "Not provided"
        self.pCount = 1
        capturedOn.text = date
        assignAddress()
        //self.locatedAt.text = "Location: " + address!
        
    }
    
    func assignAddress(){
        locationManager.delegate = self
        CLGeocoder().reverseGeocodeLocation(location!) { (placemark, error) in
            if error != nil{
                print ("Error in reverse geocoding")
            }
            else{
                if let place = placemark?[0]
                {
                    if let street = place.subThoroughfare{
                        self.address = "\(street), \(place.thoroughfare!), \(place.locality!)."
                        self.locatedAt.text = "Location: \(street), \(place.thoroughfare!), \(place.locality!)."
                    }
                    else{
                        self.address = "\(place.thoroughfare!), \(place.locality!)."
                        self.locatedAt.text = "Location: \(place.thoroughfare!), \(place.locality!)."
                    }
                    
                }
            }
            self.activityIndicator.stopAnimating()
            self.reportButton.isEnabled = true
        }
    }
    
    
    @IBAction func pickingSeverity(_ sender: UISlider) {
        severity = Int(sender.value)
        if(severity! <= 4 ){
            sender.tintColor = .green
            sender.thumbTintColor = .green
        }
        else if(severity! < 8 ){
            sender.tintColor = .purple
            sender.thumbTintColor = .purple
        }
        else{
            sender.tintColor = .red
            sender.thumbTintColor = .red
        }
    }

    @IBAction func report(_ sender: UIButton) {
        var updateID = "default value"
        var firstCapturedOn = "first captured default"
        var updateExisting:Bool
        
        updateExisting = false
        //saving data to firebase database
        let databaseRef = FIRDatabase.database().reference()
        for i in 0..<PotholeData.potholes.count{
            if((self.latitude! == PotholeData.potholes[i].latitude!) && (self.longitude == PotholeData.potholes[i].longitude)){
                updateID = PotholeData.potholes[i].id!
                self.pCount = PotholeData.potholes[i].pCount! + 1
                if(self.additionalInfo == "Not Provided"){
                    self.additionalInfo = PotholeData.potholes[i].additionalInfo!
                }
                firstCapturedOn = PotholeData.potholes[i].FirstCapturedOn!
                updateExisting = true
                break
            }
        }
        if(updateExisting){
            let pDictionary : [String: Any] = ["id": updateID, "address": self.address!, "firstCapturedOn":firstCapturedOn, "lastCapturedOn": self.date!, "severity": self.severity!, "additionalInfo": self.additionalInfo!, "pCount":self.pCount!, "latitude": (self.latitude)!, "longitude": (self.longitude)!]
            databaseRef.child("pReport").child(updateID).setValue(pDictionary)
            //uploading image to firebase storage
            let imageStorageRef = FIRStorage.storage().reference(withPath: "pImages/\(updateID).jpg")
            let imageData = UIImageJPEGRepresentation(self.potholePhoto!, 0.3)
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            imageStorageRef.put(imageData!, metadata: uploadMetadata)
        }
        
        else{
            
            let id = databaseRef.child("pReport").childByAutoId().key
            let pDictionary : [String: Any] = ["id": id, "address": self.address!, "firstCapturedOn": self.date!, "lastCapturedOn": self.date!, "severity": self.severity!, "additionalInfo": self.additionalInfo!, "pCount":self.pCount!, "latitude": (self.latitude)!, "longitude": (self.longitude)!]
            databaseRef.child("pReport").child(id).setValue(pDictionary)
        
            //uploading image to firebase storage
            let imageStorageRef = FIRStorage.storage().reference(withPath: "pImages/\(id).jpg")
            let imageData = UIImageJPEGRepresentation(self.potholePhoto!, 0.3)
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            imageStorageRef.put(imageData!, metadata: uploadMetadata)
        }
        
        performSegue(withIdentifier: "SayThankYou", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ additionalInfoTextfield: UITextField) -> Bool {
        // Hide the keyboard.
        additionalInfoTextfield.resignFirstResponder()
        if(additionalInfoTextfield.text != nil){
            self.additionalInfo = additionalInfoTextfield.text!
        }
        
        return true
    }



}
