//
//  SecondViewController.swift
//  Assignment4
//
//  Created by prashant joshi on 10/20/17.
//  Copyright © 2017 prashant joshi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NSMachPortDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startingPosition: UISearchBar!
    @IBOutlet weak var finalPosition: UISearchBar!
    var locationManager:CLLocationManager!
    var range:CLLocationDistance = 100000
    var location: CLLocation!
    
    
    var sanDiegoCoordinate2D = CLLocationCoordinate2DMake(32.715736, -117.161087)
    var escondidoCoordinate2D = CLLocationCoordinate2DMake(33.1191667, -117.0855556)
    var elCajonCoordinate2D = CLLocationCoordinate2DMake(32.794773, -116.962524)
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 3.0
        return render
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }

    func updateMapRegion(location:CLLocationCoordinate2D, rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegionMakeWithDistance(location, rangeSpan, rangeSpan)
        //mapView.region = region
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLocation()
        self.mapView.delegate = self
        updateMapRegion(location: sanDiegoCoordinate2D, rangeSpan: range)
        locationManager.requestLocation()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        let sanDiegoPin = MKPointAnnotation()
        let escondidoPin = MKPointAnnotation()
        let elCajonPin = MKPointAnnotation()
        sanDiegoPin.coordinate = sanDiegoCoordinate2D
        escondidoPin.coordinate = escondidoCoordinate2D
        elCajonPin.coordinate = elCajonCoordinate2D
        sanDiegoPin.title = "San Diego"
        escondidoPin.title = "Escondido"
        elCajonPin.title = "El Cajon"
        mapView.addAnnotation(sanDiegoPin)
        mapView.addAnnotation(escondidoPin)
        mapView.addAnnotation(elCajonPin)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapView.showsUserLocation = true
    }
    
   func userLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User is now allowed to access the location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { print("Errors: " + error.localizedDescription)
    }
    
    @IBAction func findingDirection(_ sender: UIButton) {
        hideKeyboard()
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        var startingPositionLatitude, startingPositionLongitude, finalPositionLatitude, finalPositionLongitude: CLLocationDegrees?
        let startingPositionAnnotation = MKPointAnnotation()
        let finalPositionAnnotation = MKPointAnnotation()
        let startingPositionRequest = MKLocalSearchRequest()
        startingPositionRequest.naturalLanguageQuery = startingPosition.text!
        let startingPositionSearch = MKLocalSearch(request:startingPositionRequest)
        startingPositionSearch.start{ (response, error) in
            if response == nil{
                    let alert = UIAlertController(title: "Alert", message: "The Location is INVALID", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            }else{
                startingPositionLatitude = (response?.boundingRegion.center.latitude)!
                startingPositionLongitude = (response?.boundingRegion.center.longitude)!
                startingPositionAnnotation.title = self.startingPosition.text
                print(startingPositionLatitude!)
                print(startingPositionLongitude!)
                startingPositionAnnotation.coordinate = CLLocationCoordinate2DMake(startingPositionLatitude!, startingPositionLongitude!)
                self.mapView.addAnnotation(startingPositionAnnotation)
                
                let finalPositionRequest = MKLocalSearchRequest()
                finalPositionRequest.naturalLanguageQuery = self.finalPosition.text!
                let finalPositionSearch = MKLocalSearch(request:finalPositionRequest)
                finalPositionSearch.start{ (response, error) in
                    if response == nil{
                        let alert = UIAlertController(title: "Alert", message: "The Location is INVALID", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    }else{
                        finalPositionLatitude = (response?.boundingRegion.center.latitude)!
                        finalPositionLongitude = (response?.boundingRegion.center.longitude)!
                        finalPositionAnnotation.title = self.finalPosition.text
                        finalPositionAnnotation.coordinate = CLLocationCoordinate2DMake(finalPositionLatitude!, finalPositionLongitude!)
                        self.mapView.addAnnotation(finalPositionAnnotation)
                        let source = MKMapItem(placemark: MKPlacemark(coordinate:CLLocationCoordinate2DMake(startingPositionLatitude!, startingPositionLongitude!)))
                        let destination = MKMapItem(placemark: MKPlacemark(coordinate:CLLocationCoordinate2DMake(finalPositionLatitude!, finalPositionLongitude!)))
                        let direction = MKDirectionsRequest()
                        direction.source = source
                        direction.destination = destination
                        direction.transportType = .automobile
                        let getDirection = MKDirections(request: direction)
                        getDirection.calculate(completionHandler:
                            { response, error in
                                guard let response = response else{
                                    if error != nil{
                                        let alert = UIAlertController(title: "Alert", message: "Route is not found.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    };return
                                }
                                let route = response.routes[0]
                                self.mapView.add(route.polyline, level: .aboveRoads)
                                let rectangle = route.polyline.boundingMapRect
                                self.mapView.setRegion(MKCoordinateRegionForMapRect(rectangle), animated: true)
                                self.mapView.setVisibleMapRect(rectangle, edgePadding: UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0), animated: true)
                        })
                    }
                }
              }
            }
        }
  }

extension SecondViewController{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.4, animations: {
        })
    }
}
    
    
            
    
    

