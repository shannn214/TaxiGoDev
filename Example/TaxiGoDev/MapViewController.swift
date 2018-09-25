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

var taxiGo = TaxiGoManager.shared.taxiGo

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var searchView: SearchView!
    
    @IBOutlet weak var favoriteView: FavoriteView!
    
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
    @IBOutlet weak var favHeightConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var driverView: DriverView!

    var textFieldTag: Int?
    
    var status: String?
    
    var dic = [Status: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        getCurrentPlace()
        loadFavList()
        setupStatusDic()

        searchView.searchViewDelegate = self
        favoriteView.favoriteDelegate = self
        
        taxiGo.api.taxiGoDelegate = self
        
        driverView.alpha = 0
        driverView.cancelButton.addTarget(self, action: #selector(cancelRide), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupMapView() {
        
        mapView.delegate = self
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    }
    
    func getCurrentPlace() {

        guard let token = taxiGo.auth.accessToken else { return }

        // MARK: Google Map
        mapView.placesClient.currentPlace { (placeList, err) in

            if let err = err {
                print("Current place error: \(err.localizedDescription)")
            }
            
            if let placeList = placeList {
                let place = placeList.likelihoods.first?.place
                if let place = place {
                    self.searchView.fromTextField.text = "\(place.name)"
                    self.mapView.startAdd = place.name
                    self.mapView.startLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
                    // MARK: Requesting the nearby driver. Note that the rate limit: 5 calls per minutes.
                    taxiGo.api.getNearbyDriver(withAccessToken: token, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: { (nearbyDrivers) in
                        
                        print("Success get nearby driver.")
                        nearbyDrivers.forEach({ [weak self] (driver) in
                            self?.mapView.driverMarker.icon = UIImage(named: "car")
                            self?.mapView.driverMarker.position = CLLocationCoordinate2D(latitude: (driver?.lat)!, longitude: (driver?.lng)!)
                            self?.mapView.driverMarker.map = self?.mapView
                        })

                    }, failure: { (err) in
                        print(err.localizedDescription)
                    })
                    
                }
                
            }
            
        }
        
    }

    override func viewDidLayoutSubviews() {
        favHeightConstaint.constant = favoriteView.favTableView.contentSize.height
        favoriteView.favTableView.estimatedRowHeight = favoriteView.favTableView.contentSize.height
    }
    
    func loadFavList() {
        
        guard let token = taxiGo.auth.accessToken else { return }
        // MARK:
        taxiGo.api.getRiderInfo(withAccessToken: token, success: { [weak self] (rider) in
            
            rider.favorite?.forEach({ [weak self] (info) in
                guard let address = info.address,
                    let lat = info.lat,
                    let lng = info.lng else { return }
                let favorite = Favorite(address: address, lat: lat, lng: lng)
                self?.favoriteView.favorite.append(favorite)
            })

            self?.favoriteView.favTableView.reloadData()
            self?.favHeightConstaint.constant = self?.favoriteView.favTableView.contentSize.height ?? 0

        }) { (err) in
            print(err.localizedDescription)
        }
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        if mapView.startLocation == nil {
            let alert = UIAlertController(title: "Please enter your pick up place.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("StartLocation: nil")
        }
        
        guard let token = taxiGo.auth.accessToken, let start = mapView.startLocation, let startAddress = mapView.startAdd else { return }
        
        confirmButton.isUserInteractionEnabled = false
        
        taxiGo.api.requestARide(withAccessToken: token,
                                startLatitude: start.coordinate.latitude,
                                startLongitude: start.coordinate.longitude,
                                startAddress: startAddress,
                                endLatitude: mapView.endLocation?.coordinate.latitude,
                                endLongitude: mapView.endLocation?.coordinate.longitude,
                                endAddress: mapView.endAdd,
                                success: { [weak self] (ride) in
                                    
                                    fadeInAnimation(view: self!.driverView)

        }) { [weak self] (err) in
            print("Failed to request a ride. Error: \(err.localizedDescription)")
            self?.confirmButton.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func cancelRide() {
        
        guard let token = taxiGo.auth.accessToken, let id = taxiGo.api.id else { return }
        
        confirmButton.isUserInteractionEnabled = true
        
        // MARK: Basically, TaxiGoDev will save the ride's id when you successfully request a ride.
        taxiGo.api.cancelARide(withAccessToken: token, id: id, success: { (ride) in
            
        }) { (err) in
            print("Failed to cancel the ride. Error: \(err.localizedDescription)")
        }
        
    }
    // MARK: Handling status on view.
    func changeStatusText(rideStatus: Status) {
        driverView.status.text = rideStatus.status
    }
    
    func setupStatusDic() {
        for element in Status.allCases {
            dic.updateValue(element.status, forKey: element)
        }
    }
    
}

extension MapViewController: TaxiGoAPIDelegate {

    // MARK: By conforming TaxiGoAPIDelegate, rideDidUpdate() will keep providing the current status of your ride request.
    // It will stop abserving the ride when the ride are canceled or finished.
    func rideDidUpdate(status: String, ride: TaxiGo.API.Ride) {
        
        print(status)
        
        guard let sta = Status(rawValue: status), let updateStatus = dic[sta] else { return }
        statusAction(status: sta)
        driverView.status.text = updateStatus
        
    }
    
    func statusAction(status: Status) {
        
        switch status {
        case .driverEnroute:
            guard let token = taxiGo.auth.accessToken, let id = taxiGo.api.id else { return }
            taxiGo.api.getSpecificRideHistory(withAccessToken: token, id: id, success: { (ride) in
                
                self.driverView.name.text = ride.driver?.name
                guard let eta = ride.driver?.eta else { return }
                self.driverView.eta.text = "預計 \(updateTime(timeStemp: eta)) 分鐘後抵達"
                self.driverView.plateNumber.text = ride.driver?.plate_number
                self.driverView.vehicle.text = ride.driver?.vehicle
                
            }) { (err) in
                print("Failed to get specific ride history. Error: \(err.localizedDescription)")
            }
        case .tripCanceled, .tripFinished:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                fadeOutAnimation(view: self.driverView)
                self.driverView.initDriverView()
                self.driverView.cancelButton.isUserInteractionEnabled = true
            }
        case .tripStarted:
            driverView.cancelButton.isUserInteractionEnabled = false
        default:
            break
        }
    }
    
}

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
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
        self.mapView.startMarker.map = nil
        self.mapView.startMarker = GMSMarker(position: location)
        self.mapView.startMarker.map = self.mapView
        self.mapView.startLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        self.searchView.fromTextField.text = name
        
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.mapView.startMarker.map = nil
        self.mapView.startMarker = GMSMarker(position: coordinate)
        self.mapView.startMarker.map = self.mapView
        self.mapView.startLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.searchView.fromTextField.text = "Place did select."
    }
    
}

