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
    var potholes = [Pothole]()
    func update(newPothole: Pothole){
        if(potholes.isEmpty){
            potholes.append(newPothole)
            
        }
        else{
            for i in 0...potholes.count{
                if(newPothole.capturedOn! >= potholes[i].capturedOn!){
                    potholes.insert(newPothole, at: i)
                }
            }
        }
    }
}
