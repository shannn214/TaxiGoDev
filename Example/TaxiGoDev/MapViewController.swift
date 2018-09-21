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
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var confirmButton: CustomButton!
    
    @IBOutlet weak var favHeightConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var driverView: DriverView!
    
    var startMarker = GMSMarker()
    
    var endMarker = GMSMarker()
    
    var driverMarker = GMSMarker()

    var placesClient: GMSPlacesClient!
    
    var startAdd: String?
    
    var startLocation: CLLocation?
    
    var endAdd: String?
    
    var endLocation: CLLocation?

    var textFieldTag: Int?
    
    var status: String?
    
    var dic = [Status: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
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
        
        let position = CLLocationCoordinate2D(latitude: 25.019946, longitude: 121.528717)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 25)
        mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
        startLocation = mapView.myLocation
        mapView.mapStyle(withFileName: "style", andType: "json")
        
    }
    
    func getCurrentPlace() {

        guard let token = taxiGo.auth.accessToken else { return }

        // MARK: Google Map
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
                    let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
                    // MARK: Requesting the nearby driver. Note that the rate limit: 5 calls per minutes.
                    taxiGo.api.getNearbyDriver(withAccessToken: token, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: { (nearbyDrivers) in
                        
                        print("Success get nearby driver.")
                        nearbyDrivers.forEach({ [weak self] (driver) in
                            self?.driverMarker.icon = UIImage(named: "car")
                            self?.driverMarker.position = CLLocationCoordinate2D(latitude: (driver?.lat)!, longitude: (driver?.lng)!)
                            self?.driverMarker.map = self?.mapView
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
        
        if startLocation == nil {
            // NOTE: Call alert to notice the user fill in the address
            print("StartLocation: nil")
        }
        
        guard let token = taxiGo.auth.accessToken, let start = startLocation, let startAddress = startAdd else { return }
        
        taxiGo.api.requestARide(withAccessToken: token,
                                startLatitude: start.coordinate.latitude,
                                startLongitude: start.coordinate.longitude,
                                startAddress: startAddress,
                                endLatitude: endLocation?.coordinate.latitude,
                                endLongitude: endLocation?.coordinate.longitude,
                                endAddress: endAdd,
                                success: { [weak self] (ride) in
                                    
                                    fadeInAnimation(view: self!.driverView)

        }) { (err) in
            print("Failed to request a ride. Error: \(err.localizedDescription)")
        }
        
    }
    
    @objc func cancelRide() {
        
        guard let token = taxiGo.auth.accessToken, let id = taxiGo.api.id else { return }
        
        // MARK: Basically, TaxiGoDev will save the ride's id when you successfully request a ride.
        taxiGo.api.cancelARide(withAccessToken: token, id: id, success: { (ride) in
//            print(ride.status)
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
                print("Failed to get specific ride history")
            }
        case .tripCanceled:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                fadeOutAnimation(view: self.driverView)
                self.driverView.initDriverView()
            }
        default:
            break
        }
    }
    
}

// MARK: The extensions below are mainly for handling Google Map without any TaxiGo api usage. You can just skip them in this part.
extension MapViewController: FavoriteViewDelegate {
    
    func favoriteCellDidTap(index: IndexPath) {
        
        guard let start = startLocation else { return }
        
        searchView.fromTextField.text = favoriteView.favorite[index.row].address
        startAdd = favoriteView.favorite[index.row].address
        startLocation = CLLocation(latitude: favoriteView.favorite[index.row].lat!, longitude: favoriteView.favorite[index.row].lng!)
        startMarker.position = (startLocation?.coordinate)!
        startMarker.map = mapView
        
        if endLocation?.coordinate == nil {
            mapView.camera = GMSCameraPosition(target: start.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        } else {
            guard let end = endLocation else { return }
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
            startAdd = place.name
            startLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            startMarker.position = place.coordinate
            startMarker.map = mapView
            
            if endLocation?.coordinate == nil {
                mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            } else {
                guard let start = startLocation, let end = endLocation else { return }
                let bounds = GMSCoordinateBounds(coordinate: start.coordinate, coordinate: end.coordinate)
                mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 60, left: 50, bottom: 60, right: 50))!
            }

        case 22:
            searchView.toTextField.text = place.name
            endAdd = place.name
            endLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            endMarker.position = place.coordinate
            endMarker.map = mapView
            
            guard let start = startLocation, let end = endLocation else {
                dismiss(animated: true, completion: nil)
                return }
            let bounds = GMSCoordinateBounds(coordinate: start.coordinate, coordinate: end.coordinate)
            mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 60, left: 50, bottom: 60, right: 50))!

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
