//
//  MapCoordinator.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import UIKit

protocol MapCoordinatorProtocol {
    func pushLocationDetailVC(location: Location, aqi: Int, onChangeNickname: @escaping ()-> Void)
    func pushBookInfoVC(locationA: Location, locationB: Location, aqiA: Int, aqiB: Int)
}
public struct MapCoordinator: MapCoordinatorProtocol {
    private let nav: UINavigationController
    init(nav: UINavigationController) {
        self.nav = nav
    }
    public func pushLocationDetailVC(location: Location, aqi: Int, onChangeNickname: @escaping ()-> Void) {
        let networkManager = NetworkManager()
        let mapRP = LocationRepository(locationNetwok: LocationNetwork(manager: networkManager), aqiNetwork: AQINetwork(manager: networkManager), coreData: LocationCoreData())
        let locationUC = LocationDetailUsecase(repository: mapRP)
        let locationVM = LocationDetailViewModel(usecase: locationUC, location: location, aqi: aqi)
        let locationVC = LocationDetailViewController(viewModel: locationVM, onChangeNickname: onChangeNickname)
        nav.pushViewController(locationVC, animated: true)
    }
    
    public func pushBookInfoVC(locationA: Location, locationB: Location, aqiA: Int, aqiB: Int) {
        let bookInfoA = BookInfo(latitude: locationA.latitude, longitude: locationA.longitude, aqi: aqiA, name: locationA.name)
        let bookInfoB = BookInfo(latitude: locationB.latitude, longitude: locationB.longitude, aqi: aqiB, name: locationB.name)
        let bookRP = BookRepository(bookNetwork: BookNetwork(manager: NetworkManager()), coreData: LocationCoreData())
        let bookInfoUC = BookInfoUsecase(repository: bookRP)
        let bookInfoVM = BookInfoViewModel(usecase: bookInfoUC, requestInfoA: bookInfoA, requestInfoB: bookInfoB)
        let bookInfoVC = BookInfoViewController(viewModel: bookInfoVM)
        nav.pushViewController(bookInfoVC, animated: true)

    }
}
