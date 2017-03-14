//
//  CameraContainerViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit

class CameraContainerViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var cameraConstraints = [NSLayoutConstraint]()
    //MARK: Properties
    let imagePicker = UIImagePickerController()
    var potholeImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(self.imagePicker)
        self.view.addSubview(self.imagePicker.view)
        let leadingConstraint = self.imagePicker.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
        let trailingConstraint = self.imagePicker.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
        let topConstraint = self.imagePicker.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0)
        let bottomConstraint = self.imagePicker.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        cameraConstraints.append(contentsOf: [leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        NSLayoutConstraint.activate(cameraConstraints)
        self.imagePicker.didMove(toParentViewController: self)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.rear) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            print("Camera not available")
        }
        
    }
    //MARK: ImagePickerController methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage         
        potholeImage = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
