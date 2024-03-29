//
//  AppDelegate.swift
//  BackgroundModesSwift
//
//  Created by Alex Nagy on 12/12/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit
import CoreMotion
import UserNotifications
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //Motion Manager
    let motionManager = CMMotionManager()
    var knocked:Bool = false
    let motionUpdateInterval : Double = 1.0
    var knockReset : Double = 2.0
    

    
    private func requestNotificationAuthorization(application:UIApplication){
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        center.requestAuthorization(options: options) { (granted, error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    
//    private func requestLocationAuthorization(){
//
//            let manager = CLLocationManager()
//
//            manager.requestAlwaysAuthorization()
//
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.makeKeyAndVisible()
        let controller = MainTabBarController()
        window?.rootViewController = controller
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.8392156863, green: 0.1882352941, blue: 0.1921568627, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        
        //Notification register
        requestNotificationAuthorization(application: application)
//        requestLocationAuthorization()
//        
//        MotionKit.Singleton.sharedInstance.getAccelerometerValues(interval: 1) { (x, y, z) in
//                                
//                                print("MotionKit\(x)");
//                            }
//           //Motion Manager Logic
//            if motionManager.isDeviceMotionAvailable{
//              motionManager.deviceMotionUpdateInterval = motionUpdateInterval
//        
//        
//               motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { deviceMotion, error in
//        
//                      print("ACCC",deviceMotion?.userAcceleration.x)
//                    }
//        
//                    )
//        
//            }
        //    //End Motion Manager Logiv
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        DispatchQueue.global(qos: .background).async {

            // Background Thread

            DispatchQueue.main.async {
                LocationKit.Singleton.sharedInstance.delegate = self
                LocationKit.Singleton.sharedInstance.startUpdatingLocation()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate : LocationKitDelegate{
    func locationdidUpdateLocations(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        localNotification()
        
        
    }
    
    func localNotification(){
           let notificationPublisher = NotificationPublisher()

           notificationPublisher.sendNotification(title: "Test", subtitle: "Sub test", body: "Content of the noification", badge: 1, delayInterval: nil)
           
       }
    
    
}



