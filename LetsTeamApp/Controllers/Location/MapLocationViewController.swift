//
//  MapLocationViewController.swift
//  LetsTeamApp
//
//  Created by admin on 8/9/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapLocationViewController: UIViewController {
    var viewModal:EventListViewModal = EventListViewModal.shared
    //var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        var marker = GMSMarker()
        
        let camera = GMSCameraPosition.camera(withLatitude: self.viewModal.selectedEventLat!, longitude: self.viewModal.selectedEventLong!, zoom: 15)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        marker = GMSMarker(position: CLLocationCoordinate2D(latitude: self.viewModal.selectedEventLat!, longitude: self.viewModal.selectedEventLong!))
        marker.title = self.viewModal.selectedEvent?.EventName
        marker.map = mapView
        view = mapView
    }
    

   

}
