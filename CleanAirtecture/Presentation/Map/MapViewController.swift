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
import RxSwift
import RxCocoa

class MapViewController: UIViewController, GMSMapViewDelegate {
    private let viewModel: MapViewModelProtocol
    private let coordinator: MapCoordinatorProtocol
    private let locationManager = CLLocationManager()
    private var mapView: GMSMapView?
    private let disposeBag = DisposeBag()
    private let moveMap = PublishRelay<(latitude: Double, longitude: Double)>()
    private let getLocation = PublishRelay<Void>()
    private let markerImageView = UIImageView(image: UIImage(named: "custom_pin"))
    private let aqiLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let locationA = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    private let locationB  = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    private let setLocationButton = {
        let button = UIButton(type: .system)
        button.setTitle("SetA", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    public init(viewModel: MapViewModelProtocol, coordinator: MapCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermission()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        bindViewModel()
    }
    
    private func setUI(latitude: Double, longitude: Double) {
        let option = GMSMapViewOptions()
        option.camera = .camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        let mapView = GMSMapView(options: option)
        self.view = mapView
        self.view.isUserInteractionEnabled = true
        mapView.delegate = self
        view.addSubview(markerImageView)
        view.addSubview(aqiLabel)
        view.addSubview(containerView)
        containerView.addSubview(locationA)
        containerView.addSubview(locationB)
        containerView.addSubview(setLocationButton)
        setConstraints()

       
    }
    
    private func bindViewModel() {
        
        let output = viewModel.transform(input: MapViewModel.Input(mapPosition: moveMap.asObservable(), 
                                                                   getLocation: getLocation.asObservable()))
        output.aqi.map { "AQI - \($0)" }
            .bind(to: aqiLabel.rx.text)
            .disposed(by: disposeBag)
        
        let locations = Observable.combineLatest(output.locationA, output.locationB)
        
        locations
            .observe(on: MainScheduler.instance)
            .bind { [weak self] (locationA, locationB) in
                self?.locationA.setTitle(locationA?.location.nickname ?? locationA?.location.name ?? "A", for: .normal)
                self?.locationB.setTitle(locationB?.location.nickname ?? locationB?.location.name ?? "B", for: .normal)
            if locationA == nil {
                self?.setLocationButton.setTitle("SetA", for: .normal)
            } else if locationB == nil {
                self?.setLocationButton.setTitle("SetB", for: .normal)
            } else {
                self?.setLocationButton.setTitle("Book", for: .normal)
            }
        }.disposed(by: disposeBag)
        
        setLocationButton.rx.tap.withLatestFrom(locations)
            .bind { [weak self] (locationA, locationB) in
                if let locationA = locationA, let locationB = locationB {
                    //TODO: 세번째 페이지이동
                } else {
                    self?.getLocation.accept(())
                }
            }.disposed(by: disposeBag)
        
        locationA.rx.tap
            .withLatestFrom(output.locationA)
            .bind(onNext: { [weak self] locationA in
                if let locationA = locationA {
                    self?.coordinator.pushLocationDetailVC(location: locationA.location,
                                                           aqi: locationA.aqi)
                } else {
                    //TODO: 다섯번째 페이지이동
                }
            })
            .disposed(by: disposeBag)
        locationB.rx.tap
            .withLatestFrom(output.locationB)
            .bind(onNext: { [weak self] locationB in
                if let locationB = locationB {
                    self?.coordinator.pushLocationDetailVC(location: locationB.location,
                                                           aqi: locationB.aqi)

                } else {
                    //TODO: 다섯번째 페이지이동
                }
            })
            .disposed(by: disposeBag)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = position.target.latitude
        let longitude = position.target.longitude
        print("지도 움직임 중: 위도 = \(latitude.truncateValue()), 경도 = \(longitude.truncateValue())")
        moveMap.accept((latitude: latitude.truncateValue(), longitude: longitude.truncateValue()))
        
    }
    
    private func setConstraints() {
     
        markerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        aqiLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(40)
        }
        containerView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }
        setLocationButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.trailing.bottom.equalToSuperview()
        }
        locationA.snp.makeConstraints { make in
            make.top.equalTo(22)
            make.leading.equalToSuperview()
            make.trailing.equalTo(setLocationButton.snp.leading)
        }
        locationB.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(setLocationButton.snp.leading)
            make.bottom.equalTo(-22)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        locationManager.stopUpdatingLocation()
        print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        let latitude: Double = Double(location.coordinate.latitude)
        let longitude: Double = Double(location.coordinate.longitude)
        setUI(latitude: latitude, longitude: longitude)
        
    }
}
