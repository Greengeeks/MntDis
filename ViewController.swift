//
//  ViewController.swift
//  Andrea Pellegrin
//
//  Created by MntDis on 15/11/2019.
//  Copyright © 2019 Andrea Pellegrin. All rights reserved.
//

import UIKit
import Mapbox
import EstimoteProximitySDK

class ViewController: UIViewController, MGLMapViewDelegate {
    
    let coordinates = [
        [46.727156,12.29576051],
        [46.67828317,12.52451952],
        [46.68377028,12.71482821],
        [46.65642697,12.37282541],
        [46.77827928,12.6187759],
        [46.76078031,12.24719615],
        [46.81401918,12.41187384],
        [46.51595729,12.5010092],
        [46.54680114,12.58735266],
        [46.56686295,12.61355625],
        [46.70797833,12.6312957],
        [46.47912917,12.24937772],
        [46.78272034,12.02790502],
        [46.43525129,12.37492003],
        [46.71720843,12.71411435],
        [46.45384165,12.25981272],
        [46.6003243,12.11783038],
        [46.64086381,12.61007021],
        [46.55091812,12.43723423],
        [46.60573723,12.29101642],
        [46.50769118,12.1688668],
        [46.87196744,12.64799696],
        [46.87263706,12.28356204],
        [46.45085759,12.22691331]
    ]
    
    var locations: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 46.722340, longitude: 12.357150), zoomLevel: 9, animated: false)
        
        mapView.showsUserLocation = true
        
        for coordinate in coordinates {
            locations.append(CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
        }
        
        for location in locations {
            let marker = MGLPointAnnotation()
            marker.coordinate = location
            mapView.addAnnotation(marker)
        }
        
        view.addSubview(mapView)
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)
    }
    
}

