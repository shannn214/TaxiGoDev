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
    
    @IBOutlet weak var favoriteView: FavoriteView!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
    @IBOutlet weak var favHeightConstaint: NSLayoutConstraint!
    
    var taxiGo = TaxiGo()
    
    var destinationMarker = GMSMarker()
    
    var driverMarker = GMSMarker()
    
    var startAdd: String?
    
    var startLocation: CLLocation?
    
    var endAdd: String?
    
    var endLocation: CLLocation?

    var textFieldTag: Int?
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placesClient = GMSPlacesClient.shared()
        setupMapView()
        getCurrentPlace()
        
        searchView.searchViewDelegate = self
        favoriteView.favoriteDelegate = self
        
        loadFavList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupMapView() {
        
        let position = CLLocationCoordinate2D(latitude: 25.019946, longitude: 121.528717)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
                    self.startAdd = place.name
                    self.startLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    
                    self.taxiGo.api.getNearbyDriver(withAccessToken: Constants.token, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: { (nearbyDrivers) in
                        
                        print("Success get nearby griver.")
                        nearbyDrivers.forEach({ (driver) in
                            print(driver?.lat)
                            print(driver?.lng)
                        })

                    }, failure: { (err) in
                        print(err.localizedDescription)
                    })
                    
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
    
    // ISSUE: It doesn't work property.
    override func viewDidLayoutSubviews() {
        favHeightConstaint.constant = favoriteView.favTableView.contentSize.height
    }
    
    func loadFavList() {
        
        taxiGo.api.getRiderInfo(withAccessToken: Constants.token, success: { (rider) in
            
            rider.favorite?.forEach({ (info) in
                guard let address = info.address,
                    let lat = info.lat,
                    let lng = info.lng else { return }
                let favorite = Favorite(address: address, lat: lat, lng: lng)
                self.favoriteView.favorite.append(favorite)
            })

            self.favoriteView.favTableView.reloadData()
            
        }) { (err) in
            print(err.localizedDescription)
        }
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        taxiGo.api.requestARide(withAccessToken: Constants.token,
                                startLatitude: (startLocation?.coordinate.latitude)!,
                                startLongitude: (startLocation?.coordinate.longitude)!,
                                startAddress: startAdd!,
                                endLatitude: endLocation?.coordinate.latitude,
                                endLongitude: endLocation?.coordinate.longitude,
                                endAddress: endAdd,
                                success: { (ride) in
            // ok
//            ride.driver
        }) { (err) in
            print(err.localizedDescription)
        }
        
    }
    
}

extension MapViewController: FavoriteViewDelegate {
    
    func favoriteCellDidTap(index: IndexPath) {
        searchView.fromTextField.text = favoriteView.favorite[index.row].address
        startAdd = favoriteView.favorite[index.row].address
        startLocation = CLLocation(latitude: favoriteView.favorite[index.row].lat!, longitude: favoriteView.favorite[index.row].lng!)
        
    }
    
}

extension MapViewController: SearchViewDelegate {
    
    func favBtnDidTap() {
        favoriteView.isHidden = !favoriteView.isHidden
    }
    
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
            startAdd = place.name
            startLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)

        case 22:
            searchView.toTextField.text = place.name
            endAdd = place.name
            endLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
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
