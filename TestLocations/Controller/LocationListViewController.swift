//
//  LocationListViewController.swift
//  TestLocations
//
//  Created by Babu Gangatharan on 4/2/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit
import CoreLocation

class LocationListViewController: UIViewController {

    //--------------------------------------------------------------------------
    // MARK: Constants
    //--------------------------------------------------------------------------
    
    private struct Constant {
        static let deeplinkBaseURL = "wikipedia://"
        static let host = "places?"
    }
    
    private struct QueryKey {
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    //--------------------------------------------------------------------------
    // MARK: - IBOutlet
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    //--------------------------------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------------------------------
    
    var locations = [GeoLocation]()
    var defaultLocations = ["Amstelveen", "Paris", "Rome", "Oslo", "Prague", "Barcelona"]
    
    //--------------------------------------------------------------------------
    // MARK: - View LifeCycle
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locations"
        self.updateView()
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func updateView() {
        defaultLocations.forEach { location in
            add(with: location)
        }
        
        start()
        tableView.reloadData()
    }
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(LocationListViewController.update), name: .CustomLocationDidUpdate, object: nil)
    }
    
    @objc func update(from notification: Notification) {
        if let cityName = notification.object as? String {
            add(with: cityName)
        }
    }
    
    private func add(with location: String) {
        guard let coordinate = getCoordinate(with: location) else { return }
        
        locations.append(GeoLocation(cooridinate: coordinate, name: location))
        tableView.reloadData()
    }
    
    private func getCoordinate(with name: String) -> CLLocationCoordinate2D?  {
        var coordinate: CLLocationCoordinate2D?
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(name) { placemarks, error in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.showAlert(title: "Not Found", message: "Couldn't find the location which you entered, Please enter proper location.")
                    return
            }
            
            coordinate = location.coordinate
            self.locations.append(GeoLocation(cooridinate: location.coordinate, name: name))
            self.tableView.reloadData()
        }
        
        return coordinate
    }
    
    private func wikipediaURL(with location: GeoLocation) -> URL? {
        guard
            var urlComponents = URLComponents(string: "\(Constant.deeplinkBaseURL)\(Constant.host)"),
            var queryItems = urlComponents.queryItems
            else {
                return nil
        }
        
        queryItems.append(URLQueryItem(name: QueryKey.latitude, value: "\(location.cooridinate.latitude)"))
        queryItems.append(URLQueryItem(name: QueryKey.longitude, value: "\(location.cooridinate.longitude)"))
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    private func navigateToWikipediaApp(with location: GeoLocation) {
        guard let url = wikipediaURL(with: location) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { (success) in
            if success {
                //
            } else {
                self.showAlert(title: "Wikipedia app not available", message: "Install the Wikipedia app to enable this functionality.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        
        alertViewController.addAction(dismissAction)
        
        alertViewController.preferredAction = dismissAction
        
        present(alertViewController, animated: true, completion: nil)
    }

}

//--------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//--------------------------------------------------------------------------

extension LocationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationViewCell", for: indexPath) as? LocationViewCell,
            locations.count > 0
            else { return UITableViewCell() }
        
        
        let location = locations[indexPath.row]
        
        cell.update(with: location)
        
        return cell
    }
    
}

//--------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//--------------------------------------------------------------------------

extension LocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        self.navigateToWikipediaApp(with: location)
    }
    
}

