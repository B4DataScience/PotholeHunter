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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalInfoTextfield.delegate = self
        if let image = potholePhoto{
            imageView.image = image
        }
        else{
            print("coudnt aquire photo from showcameraViewController")
        }
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
                print ("Error in revergeocoding")
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
        var updateID = "asdasd"
        var update:Bool
        
        update = false
        //saving data to firebase database
        let databaseRef = FIRDatabase.database().reference()
        for i in 0..<PotholeData.potholes.count{
            if(self.address! == PotholeData.potholes[i].address!){
                updateID = PotholeData.potholes[i].id!
                self.pCount = PotholeData.potholes[i].pCount! + 1
                PotholeData.potholes[i].pCount = pCount
                update = true
                break
            }
        }
        if(update){
            let pDictionary : [String: Any] = ["id": updateID, "address": self.address!, "time": self.date!, "severity": self.severity!, "additionalInfo": self.additionalInfo!, "pCount":self.pCount!, "latitude": (self.location?.coordinate.latitude)!, "longitude": (self.location?.coordinate.longitude)!]
            databaseRef.child("pReport").child(updateID).setValue(pDictionary)
        }
        
        else{
            
            let id = databaseRef.child("pReport").childByAutoId().key
            let pDictionary : [String: Any] = ["id": id, "address": self.address!, "time": self.date!, "severity": self.severity!, "additionalInfo": self.additionalInfo!, "pCount":self.pCount!, "latitude": (self.location?.coordinate.latitude)!, "longitude": (self.location?.coordinate.longitude)!]
            databaseRef.child("pReport").child(id).setValue(pDictionary)
        
            //uploading image to firebase storage
            let imageStorageRef = FIRStorage.storage().reference(withPath: "pImages/\(id).jpg")
            let imageData = UIImageJPEGRepresentation(self.potholePhoto!, 0.3)
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            imageStorageRef.put(imageData!, metadata: uploadMetadata)
        }
        /*let pothole = Pothole()
        pothole.potholeImage = self.potholePhoto
        pothole.address = self.locatedAt.text
        pothole.capturedOn = self.date
        pothole.severity = self.severity
        pothole.latitude = (self.location?.coordinate.latitude)!
        pothole.longitude = (self.location?.coordinate.longitude)!
        PotholeData.potholes.append(pothole)*/
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
