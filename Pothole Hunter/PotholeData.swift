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
    static var potholes = [Pothole]()
    func update(newPothole: Pothole){
        if(PotholeData.potholes.isEmpty){
            PotholeData.potholes.append(newPothole)
            
        }
        else{
            for i in 0...PotholeData.potholes.count{
                if(newPothole.capturedOn! >= PotholeData.potholes[i].capturedOn!){
                    PotholeData.potholes.insert(newPothole, at: i)
                    break
                }
            }
        }
    }
}
