//
//  SecondViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import MapKit 
class ShowMapViewController: UIViewController,CLLocationManagerDelegate {
    
    //MARk: Properties
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var reposition: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reposition = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let location2D:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude , location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location2D, span)
        if(reposition)!{
            mapView.setRegion(region, animated: true)
            reposition = false
        }
        self.mapView.showsUserLocation = true 
    }
    @IBAction func recenterTheMap(_ sender: UIButton) {
        reposition = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

