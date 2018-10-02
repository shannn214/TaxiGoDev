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

#### Authorization

```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    taxiGo.auth.authCode = taxiGo.auth.getAuthCode(url: url)
}
```

## Author

shannn214, gracejin214@gmail.com

## License

TaxiGoDev is available under the MIT license. See the LICENSE file for more info.
