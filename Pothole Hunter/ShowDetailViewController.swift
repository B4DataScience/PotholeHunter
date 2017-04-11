//
//  ShowDetailViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-15.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import Firebase
class ShowDetailViewController: UIViewController {
    
    var indexCalled:Int?
    var date:String?
    var address:String?
    var severity:String?
    var additionalInfo:String?
    var pCount:Int?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var pCountLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = PotholeData.potholes[self.indexCalled!].potholeImage
        self.dateLabel.text = "Captured on:" + self.date!
        self.LocationLabel.text = "Location:" + self.address!
        self.severityLabel.text = "Severity:" + self.severity!
        self.additionalInfoLabel.text = "Aditional info:" + additionalInfo!
        self.pCountLabel.text = "Reports made: \(String(describing: self.pCount!))"
        if(PotholeData.potholes[self.indexCalled!].potholeImage == nil){
            let id = PotholeData.potholes[self.indexCalled!].id!
            let imageRef = FIRStorage.storage().reference(withPath: "pImages/\(id).jpg")
            imageRef.data(withMaxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error in retriving image \(error)")
                } else {
                    // Data for Image is returned
                    PotholeData.potholes[self.indexCalled!].potholeImage = UIImage(data: data!)
                    self.imageView.image = PotholeData.potholes[self.indexCalled!].potholeImage!
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}
