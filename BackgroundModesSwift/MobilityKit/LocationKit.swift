//
//  LocationKit.swift
//  BackgroundModesSwift
//
//  Created by Kishore Raj on 10/12/19.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationKitDelegate: class {
  func locationdidUpdateLocations(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}


class LocationKit :NSObject{
    
    struct Singleton {
        static let sharedInstance = LocationKit()
    }
    
    weak var delegate: LocationKitDelegate?

    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        // TODO: set desiredAccuracy to kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
//        manager.distanceFilter = 500
        // TODO: requestAlwaysAuthorization
        manager.requestAlwaysAuthorization()
        // TODO: set allowsBackgroundLocationUpdates to true
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        
        return manager
    }()
    
    
    func startUpdatingLocation() {
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()

    }
    
    func stopUpdatingLocation() {
        
        locationManager.stopUpdatingLocation()
    }
    
    
}

extension  LocationKit : CLLocationManagerDelegate{
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        self.delegate?.locationdidUpdateLocations(manager: manager, didUpdateLocations: locations)

    }
    
}
