//
//  FirstViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import AVFoundation
class ShowCameraViewController: UIViewController {
    
    /*//MARK: Properties
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var camera:AVCaptureDevice!
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    //MARK: Methods
    /*
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
        }
    
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

