//
//  AnnotationWithIdentifier.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-04-10.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import MapKit
class AnnotationWithIdentifier: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var index:Int?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle:String, index:Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.index = index
        
        super.init()
    }
    func pinColor() -> UIColor{
        if(PotholeData.potholes[self.index!].severity! <= 4){
            return MKPinAnnotationView.greenPinColor()
        }
        else if(PotholeData.potholes[self.index!].severity! < 8){
            return MKPinAnnotationView.purplePinColor()
        }
        else{
            return MKPinAnnotationView.redPinColor()
        }
    }
    
    
}
