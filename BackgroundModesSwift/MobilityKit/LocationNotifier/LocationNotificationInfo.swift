//
//  LocationNotificationInfo.swift
//  BackgroundModesSwift
//
//  Created by Kishore Raj on 17/12/19.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
