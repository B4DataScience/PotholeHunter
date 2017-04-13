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
    static var potholes = [Pothole]()
    static func potholeAdded(pReport:Dictionary<String, Any>){
        let temp = Pothole()
        temp.id = pReport["id"] as? String
        temp.address = pReport["address"] as? String
        temp.FirstCapturedOn = pReport["firstCapturedOn"] as? String
        temp.LastCapturedOn = pReport["lastCapturedOn"] as? String
        temp.severity = pReport["severity"] as? Int
        temp.additionalInfo = pReport["additionalInfo"] as? String
        temp.pCount = pReport["pCount"] as? Int
        temp.latitude = pReport["latitude"] as? Double
        temp.longitude = pReport["longitude"] as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a Z"
        temp.date = dateFormatter.date(from: temp.FirstCapturedOn!)
        if(self.potholes.count == 0){
            potholes.append(temp)
        }
        else{
            for i in 0...(self.potholes.count-1){
                
                    if(temp.date! >= potholes[i].date!){
                        self.potholes.insert(temp, at: i)
                        break
                    }
            
            }
        }
    }
    
    static func potholeUpdate(pReport:Dictionary<String, Any>){
        let updateID = pReport["id"] as? String
    
        for i in 0...self.potholes.count-1{
            if(updateID == self.potholes[i].id){
                self.potholes[i].LastCapturedOn = pReport["lastCapturedOn"] as? String
                self.potholes[i].severity = pReport["severity"] as? Int
                self.potholes[i].additionalInfo = pReport["additionalInfo"] as? String
                self.potholes[i].pCount = pReport["pCount"] as? Int
                break
            }
        }
    }
    
}
