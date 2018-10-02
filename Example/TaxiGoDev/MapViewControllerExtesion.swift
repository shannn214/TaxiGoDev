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
    
    func favoriteCellDidTap(_ favoriteView: FavoriteView, index: IndexPath) {
        
        guard let start = mapView.startLocation,
            let startLocation = mapView.startLocation,
            let lat = favoriteView.favorite[index.row].lat,
            let lng = favoriteView.favorite[index.row].lng else { return }
        
        searchView.fromTextField.text = favoriteView.favorite[index.row].address
        mapView.startAdd = favoriteView.favorite[index.row].address
        mapView.startLocation = CLLocation(latitude: lat,
                                           longitude: lng)
        mapView.startMarker.position = startLocation.coordinate
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
    
    func textFieldDidTap(_ searchView: SearchView, sender: UITextField) {
        
        let autoconpleteController = GMSAutocompleteViewController()
        autoconpleteController.delegate = self
        autoconpleteController.modalPresentationStyle = .overCurrentContext
        present(autoconpleteController, animated: true, completion: nil)
        self.searchView.activeTextField = sender
    
    }
    
    func favBtnDidTap(_ searchView: SearchView) {
        
        favoriteView.isHidden = !favoriteView.isHidden

    }
    
    func hamburgerDidTap(_ searchView: SearchView) {
       
        UIView.animate(withDuration: 0.2) {
            self.userView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: UIScreen.main.bounds.width * 0.6,
                                         height: UIScreen.main.bounds.height)
        }
    
    }
    
}

extension MapViewController: UserViewDelegate {
    
    func logoutDidTap(_ userView: UserView) {
        
        presentAlert(title: "確認要登出裝置？", message: nil, cancel: true) { (UIAlertAction) in
            let logoutDefault = UserDefaults.standard
            logoutDefault.removeObject(forKey: "access_token")
            logoutDefault.synchronize()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UIStoryboard.loginStoryboard().instantiateInitialViewController()
        }
        
    }
    
}

// NOTE: Should refactor switch tag part.
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.searchView.activeTextField?.text = place.name
        
        switch searchView.activeTextField {
        case searchView.fromTextField:
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
            
        case searchView.toTextField:
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
        
        switch searchView.activeTextField {
            
        case searchView.fromTextField:
            self.mapView.startMarker.map = nil
            self.mapView.startMarker = GMSMarker(position: coordinate)
            self.mapView.startMarker.map = self.mapView
            self.mapView.startLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            nativeGeoManager.getAddressFromGeo(lat: coordinate.latitude, lng: coordinate.longitude, completion: { (address) in
                guard let add = address else { return }
                self.searchView.fromTextField.text = add
                self.mapView.startAdd = add
            })
        case searchView.toTextField:
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

