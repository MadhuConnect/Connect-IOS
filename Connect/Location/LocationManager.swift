//
//  LocationManager.swift
//  MyCurrentLoc
//
//  Created by Venkatesh Botla on 30/07/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MyLocationManagerDelegate {
    func didGetErrorForPermissions(withTitle title: String, andError error: String)
    func didGetLocation(withLocation name: String?, latitude: Double?, longitude: Double?)
}

public class MyLocationManager: NSObject {
    
    var locationManager: CLLocationManager?
    var delegate: MyLocationManagerDelegate?
    private let client = APIClient()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.distanceFilter = 100
        
    }
    
    func checkLocationPermissions() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        case .restricted:
            delegate?.didGetErrorForPermissions(withTitle: "restricted", andError: "Location access restricted from parent control.")
        case .denied:
            delegate?.didGetErrorForPermissions(withTitle: "denied", andError: "Location access denied. Please allow it from settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
        default:
            delegate?.didGetErrorForPermissions(withTitle: "unknown", andError: "Something went wrong")
        }
    }
    
    func getLocationDetails(fromLocation location: CLLocation) {
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
//        print("Lat: \(latitude), Lng: \(longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                self.delegate?.didGetErrorForPermissions(withTitle: "Error", andError: error.localizedDescription)
            } else if let placemarks = placemarks {
                for placemark in placemarks {
                    let address = [placemark.name, placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.subAdministrativeArea, placemark.country, placemark.postalCode].compactMap({$0}).joined(separator: ", ")
                    print(address)
                    
                    guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
                        return
                    }
                    
                    self.updateLocationToServer(witUser: userId, lat: latitude, lng: longitude, location: placemark.name ?? "")
                    self.delegate?.didGetLocation(withLocation: "\(placemark.locality ?? ""), \(placemark.locality ?? ""), \(placemark.postalCode ?? "")", latitude: latitude, longitude: longitude)
                }
            }
        }
    }
    
}

extension MyLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationPermissions()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError -- Location: \(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.getLocationDetails(fromLocation: location)
        }
    }
    
}

extension MyLocationManager {
    func updateLocationToServer(witUser id: Int, lat: Double, lng: Double, location: String) {
        let parameters = CoordinatesReqModel(userId: id, latitude: lat, longitude: lng, location: location)
        
        print("Par: \(parameters)")
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .updateCoordinates
        
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)
        client.post_updateCoordinates(from: endpoint) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }

                if response.status {
                    print(response)
                } else {
                    print(response.message as Any)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }

    
}
