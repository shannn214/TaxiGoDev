//
//  MapViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import TaxiGoDev
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var taxiGo = TaxiGo()
    
    var destinationMarker = GMSMarker()
    
    var driverMarker = GMSMarker()
    
    var placesClient: GMSPlacesClient!
    
    var fromTextField: CustomTextField!
    
    var toTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placesClient = GMSPlacesClient.shared()
        setupMapView()
        getCurrentPlace()
        
        setupTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupMapView() {
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        mapView.mapType = .normal
        
        let position = CLLocationCoordinate2D(latitude: 25.019946, longitude: 121.528717)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
        
    }
    
    fileprivate func setupTextField() {
        
        fromTextField = CustomTextField(frame: CGRect(x: 50, y: 50, width: 250, height: 50))
        fromTextField.placeholder = "Current place"
        fromTextField.tag = 1
        toTextField = CustomTextField(frame: CGRect(x: 50, y: 120, width: 250, height: 50))
        toTextField.placeholder = "Destination"
        toTextField.tag = 2
//        fromTextField.tapDelegate = self
        toTextField.tapDelegate = self
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        
    }
    
    func getCurrentPlace() {
        
        placesClient.currentPlace { (placeList, err) in
            
            if let err = err {
                print("Current place error: \(err.localizedDescription)")
            }
            
            if let placeList = placeList {
                let place = placeList.likelihoods.first?.place
                if let place = place {
                    self.fromTextField.text = "\(place.name)"
                    
                    self.taxiGo.api.getNearbyDriver(withAccessToken: Constants.token, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: {
                        print("Success get nearby griver.")
                        
                    }, failure: { (err) in
                        
                    })
                    
                }
            }
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
//        destinationMarker.position = location
//        destinationMarker.map = mapView
//        mapView.selectedMarker = destinationMarker
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        destinationMarker.position = coordinate
        destinationMarker.map = mapView
        mapView.selectedMarker = destinationMarker
        toTextField.text = "\(coordinate)"
    }
    
}

extension MapViewController: CustomTextFieldDelegate {
    
    func textFieldDidTap(_ controller: CustomTextField) {
        let autoconpleteController = GMSAutocompleteViewController()
        autoconpleteController.delegate = self
        autoconpleteController.modalPresentationStyle = .overCurrentContext
        present(autoconpleteController, animated: true, completion: nil)
    }

}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // NOTE: two text fields to handle
        
        toTextField.text = "\(place.name)"
        destinationMarker.position = place.coordinate
        destinationMarker.map = mapView
        dismiss(animated: true, completion: nil)

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
