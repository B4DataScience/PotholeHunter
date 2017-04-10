//
//  PotholeData.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-15.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class PotholeData{
    static var firstUpdate = true
    static var potholes = [Pothole]()
    static func update(pReport:Dictionary<String, Any>){
        let temp = Pothole()
        temp.id = pReport["id"] as? String
        temp.address = pReport["address"] as? String
        temp.capturedOn = pReport["time"] as? String
        temp.severity = pReport["severity"] as? Int
        temp.latitude = pReport["latitude"] as? Double
        temp.longitude = pReport["longitude"] as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a Z"
        temp.date = dateFormatter.date(from: temp.capturedOn!)
        if(self.potholes.count == 0){
            potholes.append(temp)
        }
        else{
            for i in stride(from: self.potholes.count, to:0, by:-1){
                
                    if(temp.date! >= potholes[i-1].date!){
                        self.potholes.insert(temp, at: i)
                        break
                    }
                
            }
                
            
        }
    }
    static func getImage(i:Int){
        if(PotholeData.potholes[i].potholeImage == nil){
            let id = PotholeData.potholes[i].id!
            let imageRef = FIRStorage.storage().reference(withPath: "pImages/\(id).jpg")
            imageRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error in retriving image \(error)")
                } else {
                    // Data for Image is returned
                    PotholeData.potholes[i].potholeImage = UIImage(data: data!)
                }
            }
        
        }
        
    }
}
