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
    
    var startMarker = GMSMarker()
    
    var endMarker = GMSMarker()
    
    var driverMarker = GMSMarker()

    var placesClient: GMSPlacesClient!
    
    var statusView: StatusView!
        
    var startAdd: String?
    
    var startLocation: CLLocation?
    
    var endAdd: String?
    
    var endLocation: CLLocation?

    var textFieldTag: Int?
    
    var confirmFlag = true
    
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxiGo.auth.accessToken = Constants.token
        
        placesClient = GMSPlacesClient.shared()
        setupMapView()
        getCurrentPlace()
        loadFavList()

        searchView.searchViewDelegate = self
        favoriteView.favoriteDelegate = self
        
        taxiGo.api.taxiGoDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addStatusView() {
        
        statusView = StatusView(frame: CGRect(x: 150, y: 300, width: 150, height: 150))
        view.addSubview(statusView)
        statusView.StatusLabel.text = "nothing"

    }
    
    func changeStatusText(rideStatus: Status) {
        statusView.StatusLabel.text = rideStatus.status

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
                    
                    self.taxiGo.api.getNearbyDriver(withAccessToken: self.taxiGo.auth.accessToken!, lat: place.coordinate.latitude, lng: place.coordinate.longitude, success: { (nearbyDrivers) in
                        
                        print("Success get nearby griver.")
                        nearbyDrivers.forEach({ (driver) in
                            self.driverMarker.icon = UIImage(named: "car")
                            self.driverMarker.position = CLLocationCoordinate2D(latitude: (driver?.lat)!, longitude: (driver?.lng)!)
                            self.driverMarker.map = self.mapView
                        })

                    }, failure: { (err) in
                        print(err.localizedDescription)
                    })
                    
                }
                
            }
            
        }
        
    }
    
    // ISSUE: It's so weird... but it works...
    override func viewDidLayoutSubviews() {
        favHeightConstaint.constant = favoriteView.favTableView.contentSize.height
        favoriteView.favTableView.estimatedRowHeight = favoriteView.favTableView.contentSize.height
    }
    
    func loadFavList() {
        
        taxiGo.api.getRiderInfo(withAccessToken: taxiGo.auth.accessToken!, success: { (rider) in
            
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
        
        if confirmFlag {

            taxiGo.api.requestARide(withAccessToken: taxiGo.auth.accessToken!,
                                    startLatitude: (startLocation?.coordinate.latitude)!,
                                    startLongitude: (startLocation?.coordinate.longitude)!,
                                    startAddress: startAdd!,
                                    endLatitude: endLocation?.coordinate.latitude,
                                    endLongitude: endLocation?.coordinate.longitude,
                                    endAddress: endAdd,
                                    success: { (ride) in

                                        self.confirmButton.titleLabel?.text = "Cancel"
                                        self.confirmFlag = false
                                        
                                        self.addStatusView()
                                        
            }) { (err) in
                print(err.localizedDescription)
            }

        } else {

            taxiGo.api.cancelARide(withAccessToken: taxiGo.auth.accessToken!, id: taxiGo.api.id!, success: { (ride) in
                print(ride.status)
                self.confirmButton.titleLabel?.text = "Confirm"
                self.confirmFlag = true
            }) { (err) in
                print("Failed to cancel.")
            }

        }

        
    }
    
}

extension MapViewController: FavoriteViewDelegate {
    
    func favoriteCellDidTap(index: IndexPath) {
        
        searchView.fromTextField.text = favoriteView.favorite[index.row].address
        startAdd = favoriteView.favorite[index.row].address
        startLocation = CLLocation(latitude: favoriteView.favorite[index.row].lat!, longitude: favoriteView.favorite[index.row].lng!)
        startMarker.position = (startLocation?.coordinate)!
        startMarker.map = mapView
        
        if endLocation?.coordinate == nil {
            mapView.camera = GMSCameraPosition(target: (startLocation?.coordinate)!, zoom: 15, bearing: 0, viewingAngle: 0)
        } else {
            let bounds = GMSCoordinateBounds(coordinate: (startLocation?.coordinate)!, coordinate: (endLocation?.coordinate)!)
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
                let bounds = GMSCoordinateBounds(coordinate: (startLocation?.coordinate)!, coordinate: (endLocation?.coordinate)!)
                mapView.camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 60, left: 50, bottom: 60, right: 50))!
            }

        case 22:
            searchView.toTextField.text = place.name
            endAdd = place.name
            endLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            endMarker.position = place.coordinate
            endMarker.map = mapView
            
            let bounds = GMSCoordinateBounds(coordinate: (startLocation?.coordinate)!, coordinate: (endLocation?.coordinate)!)
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

extension MapViewController: TaxiGoAPIDelegate {
    
    func rideDidUpdate(status: String) {
        print(status)
        
        if status == Status.tripCanceled.rawValue {
            changeStatusText(rideStatus: .tripCanceled)
        }

    }
    
}

