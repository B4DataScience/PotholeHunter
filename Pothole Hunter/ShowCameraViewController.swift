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
class ShowCameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,CLLocationManagerDelegate {
    
    //var cameraConstraints = [NSLayoutConstraint]()
    var takePhoto = false//to take only one photo from queue set it false once captured
    let locationManager = CLLocationManager()
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var camera:AVCaptureDevice!
    var location:CLLocation?
    var potholeImage:UIImage?
    

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
        
        
        /*if let cameraVC = storyboard?.instantiateViewController(withIdentifier: "CameraInterface"){
            //self.addChildViewController(cameraVC)
            //self.view.addSubview(
            let leadingConstraint = cameraVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
            let trailingConstraint = cameraVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
            let topConstraint = cameraVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0)
            let bottomConstraint = cameraVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
            cameraConstraints.append(contentsOf: [leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
            NSLayoutConstraint.activate(cameraConstraints)
            
        }*/
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopCaptureSession()
        self.locationManager.stopUpdatingLocation()
    }
    //MARK: CLLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        
    }
    
    //MARK: Methods
    
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let avilableCamera = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices{
            camera = avilableCamera.first
        }
        beginSession()
    }
    func beginSession(){
        do{
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(cameraInput)
        }
        catch{
            print(error.localizedDescription)
        }
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            let cameraOutput = AVCaptureVideoDataOutput()
            cameraOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            cameraOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(cameraOutput) {
                captureSession.addOutput(cameraOutput)
            }
            else{
                print("Cannot take camra output")
            }
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "potholeCaptureQueue")
            cameraOutput.setSampleBufferDelegate(self, queue: queue)
        }
    
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        takePhoto = true
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto{
            takePhoto = false//to take only one photo
            
                potholeImage = self.getImageFromSampleBuffer(buffer: sampleBuffer) /*{
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                photoVC.potholePhoto = image*/
            DispatchQueue.main.async {}
            performSegue(withIdentifier: "EnterDetail", sender: self)
                
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterDetail"{
            if let destinatioVC = segue.destination as? PhotoViewController{
                destinatioVC.potholePhoto = self.potholeImage
                destinatioVC.location = self.location
                destinatioVC.date = Date()
                self.stopCaptureSession()
            }
        }
    }
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage?{
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {//taking image from buffer
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)//coreimage
            let context = CIContext()//context to render the image
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))//setting dimension of image
            
            if let image = context.createCGImage(ciImage, from: imageRect) {//making image from core image
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        
        return nil
    }
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

