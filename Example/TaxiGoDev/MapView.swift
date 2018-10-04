//
//  Map.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapView: GMSMapView {
    
    var placesClient: GMSPlacesClient!
    var startMarker = GMSMarker()
    var endMarker = GMSMarker()
    var driverMarker = GMSMarker()
    var driversMarker = [GMSMarker]()
    var geocoder = GMSGeocoder()
    var driverLocation: CLLocation?
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    var startAdd: String?
    var endAdd: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    func initialSetup() {
        
        placesClient = GMSPlacesClient.shared()
        let position = CLLocationCoordinate2D(latitude: 25.019946, longitude: 121.528717)
        self.isMyLocationEnabled = true
        self.settings.compassButton = true
        self.settings.myLocationButton = true
        self.padding = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 25)
        self.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
        startLocation = self.myLocation
        self.mapStyle(withFileName: "style", andType: "json")

    }

}

