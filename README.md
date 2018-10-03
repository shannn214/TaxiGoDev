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
You can access an API like this:
```
var taxiGo = TaxiGo.shared
```

#### Setup
```
taxiGo.auth.appID = <YOUR_APPID>
taxiGo.auth.appSecret = <YOUR_APP_SECRET>
taxiGo.auth.redirectURL = <YOUR_REDIRECTURL>
taxiGo.api.url = <SAND_BOX_URL/PRODUCTION_URL>
taxiGo.api.apiKey = <YOUR_API_KEY>
```

#### Authorization
TaxiGo provides an authorization page where user can sign in with their LINE account and grant permission to your application. In the example, we use `UIApplication` to open the url.
```
let url = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=<YOUR_APPID>&redirect_uri=<YOUR_REDIRECTURL>")
UIApplication.shared.open(url, options: [:], completionHandler: nil)
```
If you successfully sign in with your LINE account, TaxiGo will return a redirect uri along with an authorization code. You can access the authorization code as following:
In  `AppDelegate.swift`, add the following to your `application(_:open:options:)` method.
```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    taxiGo.auth.authCode = taxiGo.auth.getAuthCode(url: url)
}
```
After you access the authorization code, you will be able to retrieve your access token and start using TaxiGo's API.
```
taxiGo.auth.getUserToken(success: { (auth) in

    // do something with the auth
    print(auth.access_token)
    ...

}) { (err) in
    // do somwthing with the err
}
```

#### Request a ride
We provide `taxiGo.api.startObservingStatus` to observe the status of ride. 
```
taxiGo.api.requestARide(withAccessToken: String, 
                        startLatitude: Double, 
                        startLongitude: Double, 
                        startAddress: String, 
                        endLatitude: Double?, 
                        endLongitude: Double?, 
                        endAddress: String?, 
                        success: { (ride, response) in
                        
                            taxiGo.api.startObservingStatus = true
                            // do something with the ride and response
                            // response will privide you the status code

}) { (err) in
    // do something with the err
}
```
#### Cancel a ride
If you successfully request a ride, TaxiGoDev will save the ride's id in `taxiGo.api.id`. You can also store the data in your way. 
```
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



## Author

shannn214, gracejin214@gmail.com

## License

TaxiGoDev is available under the MIT license. See the LICENSE file for more info.
