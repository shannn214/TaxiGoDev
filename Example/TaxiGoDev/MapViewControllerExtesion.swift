//
//  MapViewControllerExtesion.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

// MARK: The extensions below are mainly for handling Google Map without any TaxiGo api usage. You can just skip them in this part.
extension MapViewController: FavoriteViewDelegate {
    
    func favoriteCellDidTap(index: IndexPath) {
        
        guard let start = mapView.startLocation else { return }
        
        searchView.fromTextField.text = favoriteView.favorite[index.row].address
        mapView.startAdd = favoriteView.favorite[index.row].address
        mapView.startLocation = CLLocation(latitude: favoriteView.favorite[index.row].lat!, longitude: favoriteView.favorite[index.row].lng!)
        mapView.startMarker.position = (mapView.startLocation?.coordinate)!
        mapView.startMarker.map = mapView
        
        if mapView.endLocation?.coordinate == nil {
            mapView.camera = GMSCameraPosition(target: start.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        } else {
            guard let end = mapView.endLocation else { return }
            let bounds = GMSCoordinateBounds(coordinate: start.coordinate, coordinate: end.coordinate)
            mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 60, left: 50, bottom: 60, right: 50))!
        }
        
    }
    
}

extension MapViewController: SearchViewDelegate {
    
    func hamburgerDidTap() {
        
        UIView.animate(withDuration: 0.2) {
            self.userView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height)
        }
        
    }
    
    func favBtnDidTap() {
        favoriteView.isHidden = !favoriteView.isHidden
    }
    
    func textFieldDidTap(sender: UITextField) {
        
        let autoconpleteController = GMSAutocompleteViewController()
        autoconpleteController.delegate = self
        autoconpleteController.modalPresentationStyle = .overCurrentContext
        present(autoconpleteController, animated: true, completion: nil)
        
    }
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        switch searchView.textFieldTag {
        case 11:
            searchView.fromTextField.text = place.name
            mapView.startAdd = place.name
            mapView.startLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            mapView.startMarker.position = place.coordinate
            mapView.startMarker.map = mapView
            
            if mapView.endLocation?.coordinate == nil {
                mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            } else {
                guard let start = mapView.startLocation, let end = mapView.endLocation else { return }
                let bounds = GMSCoordinateBounds(coordinate: start.coordinate, coordinate: end.coordinate)
                mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 80, left: 50, bottom: 60, right: 50))!
            }
            
        case 22:
            searchView.toTextField.text = place.name
            mapView.endAdd = place.name
            mapView.endLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            mapView.endMarker.position = place.coordinate
            mapView.endMarker.map = mapView
            
            guard let start = mapView.startLocation, let end = mapView.endLocation else {
                dismiss(animated: true, completion: nil)
                return }
            let bounds = GMSCoordinateBounds(coordinate: start.coordinate, coordinate: end.coordinate)
            mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 80, left: 50, bottom: 60, right: 50))!
            
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        switch searchView.textFieldTag {
            
        case 11:
            self.mapView.startMarker.map = nil
            self.mapView.startMarker = GMSMarker(position: coordinate)
            self.mapView.startMarker.map = self.mapView
            self.mapView.startLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            nativeGeoManager.getAddressFromGeo(lat: coordinate.latitude, lng: coordinate.longitude, completion: { (address) in
                guard let add = address else { return }
                self.searchView.fromTextField.text = add
                self.mapView.startAdd = add
            })
        case 22:
            self.mapView.endMarker.map = nil
            self.mapView.endMarker = GMSMarker(position: coordinate)
            self.mapView.endMarker.map = self.mapView
            self.mapView.endLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            nativeGeoManager.getAddressFromGeo(lat: coordinate.latitude, lng: coordinate.longitude, completion: { (address) in
                guard let add = address else { return }
                self.searchView.toTextField.text = add
                self.mapView.endAdd = add
            })
        default:
            break
        }
        
    }
    
    
}
