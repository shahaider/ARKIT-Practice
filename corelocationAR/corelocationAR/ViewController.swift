//
//  ViewController.swift
//  corelocationAR
//
//  Created by Syed ShahRukh Haider on 09/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

import ARCL

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    
    var place : String!
    
    private let locationManager = CLLocationManager()
    
    let sceneView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = place
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
            findLocation()
        
        // AR view
        
        sceneView.run()
        view.addSubview(sceneView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    sceneView.frame = view.bounds
    }
    
    func findLocation(){
        
        
        // store current location value
        guard let location = self.locationManager.location else{
            return
        }
        
        // creating search request with natural language
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        
        
        // presize cordinate of user
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        request.region = region
        
        
        // link natural language value with region info list
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            
            if error != nil{
                
                return
            }
            
            guard let response = response else{
                return
                
            }
            
            for item in response.mapItems{
                
                print(item.placemark)
                
                let placelocation = (item.placemark.location)!
                
//                let image = UIImage(named: "pin.png")!
                
                let placeAnnotationNode = placeAnnotation(location: placelocation, Title: item.placemark.name!)
                
//                let annotationNode = LocationAnnotationNode(location: placelocation, image: image)
//                annotationNode.scaleRelativeToDistance = false

                DispatchQueue.main.async {
                    self.sceneView.addLocationNodeForCurrentPosition(locationNode: placeAnnotationNode)
                }
            }
        }
        
        
        
        
        
    }
 


}

