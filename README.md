# TaxiGoDev

[![CI Status](https://img.shields.io/travis/shannn214/TaxiGoDev.svg?style=flat)](https://travis-ci.org/shannn214/TaxiGoDev)
[![Version](https://img.shields.io/cocoapods/v/TaxiGoDev.svg?style=flat)](https://cocoapods.org/pods/TaxiGoDev)
[![License](https://img.shields.io/cocoapods/l/TaxiGoDev.svg?style=flat)](https://cocoapods.org/pods/TaxiGoDev)
[![Platform](https://img.shields.io/cocoapods/p/TaxiGoDev.svg?style=flat)](https://cocoapods.org/pods/TaxiGoDev)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TaxiGoDev is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TaxiGoDev'
```

## Usage
You can access TaxiGoDev API like this:
```swift
import TaxiGoDev
var taxiGo = TaxiGo.shared
```

#### Setup

- Set up Your URL Types  
Your Project -> TARGETS -> Info -> URL Types -> URL Schemes, Identifier -> <YOUR_SCHEMES>  
![image](https://github.com/shannn214/TaxiGoDev/blob/develop/Example/TaxiGoDev/Images.xcassets/URL_SCHEMES.imageset/URL_SCHEMES.png)
```swift
taxiGo.auth.appID = <YOUR_APPID>
taxiGo.auth.appSecret = <YOUR_APP_SECRET>
taxiGo.auth.redirectURL = <YOUR_REDIRECTURL>
taxiGo.api.url = <SAND_BOX_URL/PRODUCTION_URL>
taxiGo.api.apiKey = <YOUR_API_KEY>
```

#### Authorization
- **User Authorizes Your Application**  
TaxiGo provides an authorization page where user can sign in with their LINE account and grant permission to your application. In the example, we use `UIApplication` to open the url.
```swift
let url = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=<YOUR_APPID>&redirect_uri=<YOUR_REDIRECTURL>")
UIApplication.shared.open(url, options: [:], completionHandler: nil)
```
- **Redirect**  
If you successfully sign in with your LINE account, TaxiGo will return a redirect uri along with an authorization code. You can access the authorization code as following: 

In  `AppDelegate.swift`, add the following to your `application(_:open:options:)` method.
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    taxiGo.auth.authCode = taxiGo.auth.getAuthCode(url: url)
}
```
- **Get User Access Token**  
After you access the authorization code, you will be able to retrieve your access token and start using TaxiGo's API.
```swift
taxiGo.auth.getUserToken(success: { (auth) in

    // do something with the auth
    print(auth.access_token)
    print(auth.refresh_token)
    ...

}) { (err) in
    // do somwthing with the err
}
```
- **Refresh token**  
The token you access before will be expired in a week. Please use `refresh_token` to get a new `access_token`. 
```swift

taxiGo.auth.refreshToken = <YOUR_REFRESH_TOKEN>

taxiGo.auth.refreshToken(success: { (refreshToken) in
            
            // do something with the refreshToken
            print(refreshToken.access_token)
            ...

        }) { (err) in
            // do somwthing with the err
        }
```


#### Request a ride
```swift
taxiGo.api.requestARide(withAccessToken: String, 
                        startLatitude: Double, 
                        startLongitude: Double, 
                        startAddress: String, 
                        endLatitude: Double?, 
                        endLongitude: Double?, 
                        endAddress: String?, 
                        success: { (ride, response) in
                        
                            // do something with the ride and response
                            // response will provide you the status code

}) { (err) in
    // do something with the err
}
```
We also provide `taxiGo.api.startObservingStatus` to observe the status of the ride you request. Remember to start the observing **before** you request the ride.  
Sweet reminder: It will keep observing until you set the value as `false`.

```swift
taxiGo.api.startObservingStatus = true
```
If you start to observe the ride's status, you'll need to implement delegate: `TaxiGoAPIDelegate` to access the callback. It will update the status every 5 seconds.
```swift
taxiGo.api.taxiGoDelegate = self

extension ViewController: TaxiGoAPIDelegate {

    func rideDidUpdate(status: String, ride: TaxiGo.API.Ride) {

        // do somthing with the callback
        print(status) // ex. WAITING_SPECIFY
        print(ride.driver?.vehicle)
        ...

    }

}
```

#### Cancel a ride
If you successfully request a ride, TaxiGoDev will save the ride's id in `taxiGo.api.id`. 
```swift
guard let token = taxiGo.auth.accessToken,
      let id = taxiGo.api.id else { return }

taxiGo.api.cancelARide(withAccessToken: token, id: id, success: { (ride, response) in
                                    
    taxiGo.api.startObservingStatus = false
    // do something with the ride and response
    // response will provide the status code
                                            
}) { (err, response) in
    // do something with the err
}
```

#### Nearby drivers

Sweet reminder: Rate Limit - **5 calls per minute.**
```swift
taxiGo.api.getNearbyDriver(withAccessToken: token,
                        lat: place.coordinate.latitude,
                        lng: place.coordinate.longitude,
                        success: { (nearbyDrivers, response) in

                            nearbyDrivers.forEach({ (driver) in
                                print(driver.lat)
                                ...
                            })

}, failure: { (err, response) in
    // do something with the err
})
```
#### Rider

```swift
taxiGo.api.getRiderInfo(withAccessToken: token, success: { (rider, response) in
            
            print(rider.name)
            
            rider.favorite?.forEach({ (info) in
                print(info.address)
            })

}) { (err, response) in
    // do something with the err
}
```



## Author

shannn214, gracejin214@gmail.com

## License

TaxiGoDev is available under the MIT license. See the LICENSE file for more info.
