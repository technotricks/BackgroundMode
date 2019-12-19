//
//  LocationViewController.swift
//  BackgroundModesSwift
//
//  Created by Alex Nagy on 12/12/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import TinyConstraints
//import CoreLocation
import MapKit
import UserNotifications
class LocationViewController: UIViewController {
    
    private var locations: [MKPointAnnotation] = []

    
    lazy var mapView: MKMapView = {
        var mv = MKMapView()
        return mv
    }()
    
    lazy var startUpdatingLocationButton: UIButton = {
        var button = UIButton()
        button.setTitle(button.isSelected ? "Stop Updating Location" : "Start Updating Location", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627451, green: 0.2666666667, blue: 0.6784313725, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startUpdatingLocationButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func startUpdatingLocationButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
//            locationManager.startUpdatingLocation()
//            locationManager.startMonitoringSignificantLocationChanges()
//            localNotification()
            LocationKit.Singleton.sharedInstance.startUpdatingLocation()

        } else {
//            locationManager.stopUpdatingLocation()
             LocationKit.Singleton.sharedInstance.stopUpdatingLocation()
        }
        
        startUpdatingLocationButton.setTitle(startUpdatingLocationButton.isSelected ? "Stop Updating Location" : "Start Updating Location", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        
        LocationKit.Singleton.sharedInstance.delegate = self
        
        

    }
    
    func localNotification(){
        let notificationPublisher = NotificationPublisher()

        notificationPublisher.sendNotification(title: "Test", subtitle: "Sub test", body: "Content of the noification", badge: 1, delayInterval: nil)
        
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        view.addSubview(mapView)
        view.addSubview(startUpdatingLocationButton)
        
        mapView.edgesToSuperview()
        startUpdatingLocationButton.edgesToSuperview(excluding: .top, insets: .bottom(10) + .right(10) + .left(10), usingSafeArea: true)
        startUpdatingLocationButton.height(50)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: LocationKitDelegate {

    
    func locationdidUpdateLocations(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        // TODO: check applicationState
        
        if UIApplication.shared.applicationState == .active{
//            print("FG== (\)")
            
            self.mapView.showAnnotations(self.locations, animated: true)
             print("FG LOcation== Lat= \(mostRecentLocation.coordinate.latitude) Lng \(mostRecentLocation.coordinate.longitude)")
        }
        else {
            print("BG LOcation== Lat= \(mostRecentLocation.coordinate.latitude) Lng \(mostRecentLocation.coordinate.longitude)")
            
        
            
            
            
            
        }
        
         localNotification()
    }
    
}



