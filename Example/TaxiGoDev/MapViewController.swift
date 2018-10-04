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
import Kingfisher

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var favoriteView: FavoriteView!
    @IBOutlet weak var driverView: DriverView!
    @IBOutlet weak var confirmButton: CustomButton!
    @IBOutlet weak var favHeightConstaint: NSLayoutConstraint!
    
    var userView = UserView()
    var nativeGeoManager = GeocodingManager()
    var lottieManager = LottieManager()
    var dic = [Status: String]()
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        getCurrentPlace()
        loadFavList()
        setupStatusDic()

        searchView.searchViewDelegate = self
        favoriteView.favoriteDelegate = self
        userView.userViewDelegate = self
        taxiGoManager.taxiGo.api.taxiGoDelegate = self
        
        print(taxiGoManager.taxiGo.auth.accessToken)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupMapView() {
        
        mapView.delegate = self
        mapView.frame = CGRect(x: 0,
                               y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
        
        self.view.addSubview(userView)
        userView.frame = CGRect(x: -(UIScreen.main.bounds.width * 0.6),
                                y: 0,
                                width: UIScreen.main.bounds.width * 0.6,
                                height: UIScreen.main.bounds.height)
        
        driverView.cancelButton.addTarget(self, action: #selector(cancelRide), for: .touchUpInside)

    }
    
    func getCurrentPlace() {

        guard let token = taxiGoManager.taxiGo.auth.accessToken else { return }

        // MARK: Google Map
        mapView.placesClient.currentPlace { (placeList, err) in

            if let err = err {
                print("Current place error: \(err.localizedDescription)")
            }
            
            guard let placeList = placeList,
                  let place = placeList.likelihoods.first?.place else { return }
            
            self.searchView.fromTextField.text = "\(place.name)"
            self.mapView.startAdd = place.name
            self.mapView.startLocation = CLLocation(latitude: place.coordinate.latitude,
                                                    longitude: place.coordinate.longitude)
            let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude,
                                                  longitude: place.coordinate.longitude)
            self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
            // MARK: Requesting the nearby driver. Note that the rate limit: 5 calls per minutes.
            taxiGoManager.taxiGo.api.getNearbyDriver(withAccessToken: token,
                                       lat: place.coordinate.latitude,
                                       lng: place.coordinate.longitude,
                                       success: { (nearbyDrivers, response) in
                
                nearbyDrivers.forEach({ [weak self] (driver) in
                    guard let self = self,
                        let driver = driver,
                        let lat = driver.lat,
                        let lng = driver.lng else { return }
                    
                    let driverMarker = GMSMarker()
                    driverMarker.icon = UIImage(named: "car")
                    driverMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    driverMarker.map = self.mapView
                    self.mapView.driversMarker.append(driverMarker)
                })

            }, failure: { (err, response) in
                print(err.localizedDescription)
            })
            
        }
        
    }

    override func viewDidLayoutSubviews() {
        favHeightConstaint.constant = favoriteView.favTableView.contentSize.height
        favoriteView.favTableView.estimatedRowHeight = favoriteView.favTableView.contentSize.height
    }
    
    func loadFavList() {
        
        favoriteView.isHidden = true
        guard let token = taxiGoManager.taxiGo.auth.accessToken else { return }
        // MARK: Get rider's information.
        taxiGoManager.taxiGo.api.getRiderInfo(withAccessToken: token, success: { [weak self] (rider, response) in
            
            guard let self = self else { return }
            let url = URL(string: rider.profile_img ?? "")
            self.userView.userImage.kf.setImage(with: url)
            self.userView.bgUserImage.kf.setImage(with: url)
            self.userView.userName.text = rider.name
            
            rider.favorite?.forEach({ [weak self] (info) in
                guard let self = self,
                    let address = info.address,
                    let lat = info.lat,
                    let lng = info.lng else { return }
                let favorite = Favorite(address: address, lat: lat, lng: lng)
                self.favoriteView.favorite.append(favorite)
            })

            self.favoriteView.favTableView.reloadData()
            self.favHeightConstaint.constant = self.favoriteView.favTableView.contentSize.height 

        }) { (err, response) in
            print(err.localizedDescription)
        }
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        if mapView.startLocation == nil {
            presentAlert(title: "請輸入叫車地點", message: nil, cancel: false, handler: nil)
            print("StartLocation: nil")
            return
        }

        guard let token = taxiGoManager.taxiGo.auth.accessToken,
            let start = mapView.startLocation,
            let startAddress = mapView.startAdd else { return }

        confirmButton.isUserInteractionEnabled = false

        taxiGoManager.taxiGo.api.startObservingStatus = true

        taxiGoManager.taxiGo.api.requestARide(withAccessToken: token,
                                startLatitude: start.coordinate.latitude,
                                startLongitude: start.coordinate.longitude,
                                startAddress: startAddress,
                                endLatitude: mapView.endLocation?.coordinate.latitude,
                                endLongitude: mapView.endLocation?.coordinate.longitude,
                                endAddress: mapView.endAdd,
                                success: { [weak self] (ride, response) in
                                    
                                    guard let self = self else { return }
                                    if response == 200 {
                                        fadeInAnimation(view: self.driverView)
                                        self.lottieManager.playLottieAnimation(view: self.driverView) // Start loading animation
                                        return
                                    }
                                    self.presentAlert(title: "發生錯誤，請稍後再試。", message: nil, cancel: false, handler: nil)
                                    self.confirmButton.isUserInteractionEnabled = true

        }) { [weak self] (err, response) in
            guard let self = self else { return }
            print("Failed to request a ride. Error: \(err.localizedDescription)")
            self.confirmButton.isUserInteractionEnabled = true
            taxiGoManager.taxiGo.api.startObservingStatus = false
        }
        
    }
    
    @objc func cancelRide() {
        
        guard let token = taxiGoManager.taxiGo.auth.accessToken,
            let id = taxiGoManager.taxiGo.api.id else { return }
        
        confirmButton.isUserInteractionEnabled = true
        
        // MARK: Basically, TaxiGoDev will save the ride's id when you successfully request a ride.
        taxiGoManager.taxiGo.api.cancelARide(withAccessToken: token, id: id, success: { (ride, response) in
            
            if response != 200 {
                self.presentAlert(title: "發生錯誤，請稍後再試。", message: nil, cancel: false, handler: nil)
            }
            taxiGoManager.taxiGo.api.startObservingStatus = false
            
        }) { (err, response) in
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
    func rideDidUpdate(status: String, ride: TaxiGo.API.Ride) {
        
        guard let sta = Status(rawValue: status),
            let updateStatus = dic[sta] else { return }
        driverView.status.text = updateStatus
        statusAction(status: sta)
        
        guard let eta = ride.driver?.eta else { return }
        lottieManager.stopLottieAnimation() // Stop loading animation
        driverView.name.text = ride.driver?.name
        driverView.eta.text = "預計 \(updateTime(timeStemp: eta)) 分鐘後抵達"
        driverView.plateNumber.text = ride.driver?.plate_number
        driverView.vehicle.text = ride.driver?.vehicle

    }
    
    func statusAction(status: Status) {
        
        switch status {
        case .tripStarted:
            driverView.cancelButton.isUserInteractionEnabled = false
        case .tripCanceled, .tripFinished, .tripPaymentProcessed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                fadeOutAnimation(view: self.driverView)
                self.driverView.initDriverView()
                self.driverView.cancelButton.isUserInteractionEnabled = true
                taxiGoManager.taxiGo.api.startObservingStatus = false
            }
            confirmButton.isUserInteractionEnabled = true
        case .driverEnroute:
            print("show enroute driver on map")
//            self.mapView.clear()
            
        default:
            break
        }
    }
    
}



