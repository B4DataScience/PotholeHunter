//
//  PhotoViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit


class PhotoViewController: UIViewController {
    //MARK: Properties
    var potholePhoto:UIImage?
    var altitude:Double?
    var longitude:Double?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = potholePhoto{
            imageView.image = image
        }
        else{
            print("coudnt aquire photo from showcameraViewController")
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
