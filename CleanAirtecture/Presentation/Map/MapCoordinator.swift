//
//  MapCoordinator.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import UIKit

protocol MapCoordinatorProtocol {
    func pushLocationDetailVC(location: Location, aqi: Int)
}
public struct MapCoordinator: MapCoordinatorProtocol {
    private let nav: UINavigationController
    init(nav: UINavigationController) {
        self.nav = nav
    }
    public func pushLocationDetailVC(location: Location, aqi: Int) {
        let networkManager = NetworkManager()
        let mapRP = LocationRepository(locationNetwok: LocationNetwork(manager: networkManager), aqiNetwork: AQINetwork(manager: networkManager), coreData: LocationCoreData())
        let locationUC = LocationDetailUsecase(repository: mapRP)
        let locationVM = LocationDetailViewModel(usecase: locationUC, location: location, aqi: aqi)
        let locationVC = LocationDetailViewController(viewModel: locationVM)
        nav.pushViewController(locationVC, animated: true)
    }
}
