//
//  ShowDetailViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-15.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {
    
    var indexCalled:Int?
    var date:String?
    var address:String?
    var severity:String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var severityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = PotholeData.potholes[self.indexCalled!].potholeImage
        self.dateLabel.text = self.date
        self.LocationLabel.text = self.address
        self.severityLabel.text = self.severity
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}
