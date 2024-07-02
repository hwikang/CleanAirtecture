//
//  MapViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/1/24.
//

import UIKit
import CoreLocation
import GoogleMaps
import SnapKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    private let locationManager = CLLocationManager()
    private var mapView: GMSMapView?
    private let markerImageView = UIImageView(image: UIImage(named: "custom_pin"))
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermission()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    private func setUI(latitude: Double, longitude: Double) {
        let option = GMSMapViewOptions()
        option.camera = .camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        let mapView = GMSMapView(options: option)
        self.view = mapView
        view.addSubview(markerImageView)
        markerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        mapView.delegate = self
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = position.target.latitude
        let longitude = position.target.longitude
        print("지도 움직임 중: 위도 = \(latitude), 경도 = \(longitude)")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        let latitude: Double = Double(location.coordinate.latitude)
        let longitude: Double = Double(location.coordinate.longitude)
        setUI(latitude: latitude, longitude: longitude)
        locationManager.stopUpdatingLocation()
    }
}

