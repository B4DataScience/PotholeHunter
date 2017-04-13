//
//  FirstViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import CoreLocation
class ShowCameraViewController: UIViewController,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    let locationManager = CLLocationManager()
    //MARK: Properties
    var location:CLLocation?
    var potholeImage:UIImage?
    let imagePicker = UIImagePickerController()
    var date:Date?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var proccedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        proccedButton.isEnabled = false
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        }
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    //MARK: LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterDetail"{
            if let destinatioVC = segue.destination as? PhotoViewController{
                destinatioVC.potholePhoto = self.potholeImage
                destinatioVC.location = self.location
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy h:mm a Z"
                destinatioVC.date = dateFormatter.string(from: self.date!)
                
                
               
                //self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        potholeImage = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.imageView.image = potholeImage
        self.date = Date()
        self.proccedButton.isEnabled = true
    }
    @IBAction func reportMore(sender: UIStoryboardSegue){
        self.imageView.image = #imageLiteral(resourceName: "defaultPhoto")
    }
    
    @IBAction func tappedForPhoto(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func go(_ sender: UIButton) {
        performSegue(withIdentifier: "EnterDetail", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

