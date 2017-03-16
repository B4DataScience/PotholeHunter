//
//  FirstViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
class ShowCameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    let locationManager = CLLocationManager()
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var camera:AVCaptureDevice!
    var location:CLLocation?
    var potholeImage:UIImage?
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterDetail"{
            if let destinatioVC = segue.destination as? PhotoViewController{
                destinatioVC.potholePhoto = self.potholeImage
                destinatioVC.location = self.location
                destinatioVC.date = Date()
               // self.stopCaptureSession()
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
    }
    @IBAction func reportMore(sender: UIStoryboardSegue){
        
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

