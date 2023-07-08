//
//  FBShared.swift
//  Mark
//
//  Created by jyck on 2023/6/27.
//

import Foundation
import CoreLocation
import LBXPermission

extension Notification.Name {
    static let onLoadLocationNotification = Notification.Name(rawValue: "onLoadLocationNotification")
}

class FBShared {
    static let shared = FBShared()
    var date2: Date = Date()
    var date: Date = Date()
    var latitude: Double = 0
    var longitude: Double = 0
    
    var locationManager =  LocationManager.sharedInstance
    
    var city: String = ""
    var state: String = ""
    var area: String = ""
    
    var rows:[MarkModel.Style:[MarkModel.Row]] = [:]
    
    
    func onSetup() {
        MarkModel.Style.allCases.forEach({
            rows[$0] = $0.rows
        })
    }
    
    func fetchpermsissions() {
        if LBXPermissionLocation.authorized() {
            self.start()
        }
    }
    
    
    func setup() {
        locationManager.showVerboseMessage = true
        locationManager.autoUpdate = false

        if LBXPermissionLocation.authorized() {
            self.start()
        }
    }
    
    
    func start(_ success: FBCallback? = nil) {
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            self.latitude = latitude
            self.longitude = longitude
            print("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
            
            print(verboseMessage)
            self.geocodeLocation(success)
            /*
             self.location = location
             let geoCoder = CLGeocoder()
             geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                 if let placemark = placemarks?.first {
                     self.city = placemark.locality ?? ""
                     self.area = placemark.name ?? ""
                     self.state = placemark.addressDictionary?["State"] as? String ?? ""
                     NotificationCenter.default.post(name: .onLoadLocationNotification, object: nil)
                 }
             }
             */
            
        }

    }
    
    func geocodeLocation(_ success: FBCallback? = nil) {
        locationManager.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude) { (reverseGecodeInfo,placemark,error) -> Void in
            self.city = placemark?.locality ?? ""
            self.area = placemark?.name ?? ""
            self.state = placemark?.addressDictionary?["State"] as? String ?? ""
            NotificationCenter.default.post(name: .onLoadLocationNotification, object: nil)
            
            if(error != nil){
                
                print(error)
            }else{
                
                print(reverseGecodeInfo!)
            }
            success?()
            
        }
    }
}
