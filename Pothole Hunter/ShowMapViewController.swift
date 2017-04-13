//
//  SecondViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-13.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
class ShowMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    
    //MARk: Properties
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var reposition: Bool?
    var annotations = [AnnotationWithIdentifier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reposition = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
        for i in 0..<PotholeData.potholes.count{
            let coordinate = CLLocationCoordinate2DMake(PotholeData.potholes[i].latitude!, PotholeData.potholes[i].longitude!)
            let title = PotholeData.potholes[i].address!
            let subtitle = "Severity: \(PotholeData.potholes[i].severity!)"
            let annotation = AnnotationWithIdentifier(coordinate: coordinate,title: title,subtitle: subtitle,index: i)
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.removeAnnotations(self.annotations)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if (annotation .isKind(of: MKUserLocation.self)){return nil}
        let annotation = annotation as? AnnotationWithIdentifier
        let identifier = "pin"
        let view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView { // 2
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        view.pinTintColor = annotation?.pinColor()
        view.animatesDrop = true
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapToDetail", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let annotation = (sender as? MKAnnotationView)?.annotation as? AnnotationWithIdentifier{
            if let destinationVC = segue.destination as? ShowDetailViewController{
                destinationVC.address = PotholeData.potholes[(annotation.index)!].address!
                destinationVC.firstCapturedOn = PotholeData.potholes[(annotation.index)!].FirstCapturedOn!
                destinationVC.lastCapturedOn = PotholeData.potholes[(annotation.index)!].LastCapturedOn!
                destinationVC.severity = String(PotholeData.potholes[(annotation.index)!].severity!)
                destinationVC.additionalInfo = PotholeData.potholes[(annotation.index)!].additionalInfo!
                destinationVC.pCount = PotholeData.potholes[(annotation.index)!].pCount!
                destinationVC.indexCalled = annotation.index!
            }
        }
    }
    
    
    func getCurrentLocation(){
    
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
        
    }
    @IBAction func recenterTheMap(_ sender: UIButton) {
        reposition = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}

