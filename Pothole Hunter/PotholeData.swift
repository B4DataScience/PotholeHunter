//
//  PotholeData.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-15.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import Foundation
import UIKit
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
}
