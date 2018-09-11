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
    
    @IBOutlet weak var searchView: SearchView!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
    var taxiGo = TaxiGo()
    
    var destinationMarker = GMSMarker()
    
    var driverMarker = GMSMarker()
    
    var fromPlace: GMSPlace?
    
    var toPlace: GMSPlace? = nil
    
    var textFieldTag: Int?
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placesClient = GMSPlacesClient.shared()
        setupMapView()
        getCurrentPlace()
        
        searchView.searchViewDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupMapView() {
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let position = CLLocationCoordinate2D(latitude: 25.019946, longitude: 121.528717)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
        
    }
    
    func getCurrentPlace() {
        
        placesClient.currentPlace { (placeList, err) in
            
            if let err = err {
                print("Current place error: \(err.localizedDescription)")
            }
            
            if let placeList = placeList {
                let place = placeList.likelihoods.first?.place
                if let place = place {
                    self.searchView.fromTextField.text = "\(place.name)"
                    self.fromPlace = place
//                    self.taxiGo.api.getNearbyDriver(withAccessToken: Constants.token, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: { (nearbyDrivers) in
//                        print("Success get nearby griver.")
//
//                    }, failure: { (err) in
//
//                    })
                    
                }
            }
            
        }
        
    }
    
//    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
//        toTextField.text = name
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        destinationMarker.position = coordinate
//        destinationMarker.map = mapView
//        mapView.selectedMarker = destinationMarker
//    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        guard fromPlace != nil else { return }
        
        taxiGo.api.requestARide(withAccessToken: Constants.token, startLatitude: (fromPlace?.coordinate.latitude)!, startLongitude: (fromPlace?.coordinate.longitude)!, startAddress: (fromPlace?.name)!, endLatitude: toPlace?.coordinate.latitude, endLongitude: toPlace?.coordinate.longitude, endAddress: toPlace?.name, success: { (ride) in
            // ok
        }) { (err) in
            print(err.localizedDescription)
        }
        
    }
    
}

extension MapViewController: SearchViewDelegate {
    
    func textFieldDidTap(sender: UITextField) {
        
        let autoconpleteController = GMSAutocompleteViewController()
        autoconpleteController.delegate = self
        autoconpleteController.modalPresentationStyle = .overCurrentContext
        present(autoconpleteController, animated: true, completion: nil)
        textFieldTag = sender.tag
        
    }

}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        switch textFieldTag {
        case 11:
            searchView.fromTextField.text = place.name
            fromPlace = place
        case 22:
            searchView.toTextField.text = place.name
            toPlace = place
            destinationMarker.position = place.coordinate
            destinationMarker.map = mapView
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
