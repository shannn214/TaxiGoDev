//
//  NewSearchViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/10/1.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class NewSearchViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var newSearchController: UISearchController?
    var bottomSearchController: UISearchController?
    var resultView: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        newSearchController = UISearchController(searchResultsController: resultsViewController)
        newSearchController?.searchResultsUpdater = resultsViewController
        bottomSearchController = UISearchController(searchResultsController: resultsViewController)
        bottomSearchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        subView.addSubview((newSearchController?.searchBar)!)
        view.addSubview(subView)
        newSearchController?.searchBar.sizeToFit()
        
        definesPresentationContext = true
        
    }

}

extension NewSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        newSearchController?.isActive = true
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
