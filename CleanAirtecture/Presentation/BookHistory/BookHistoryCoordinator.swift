//
//  BookHistoryCoordinator.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import UIKit
protocol BookHistoryCoordinatorProtocol {
    func backToMapVC(locationA: Location, locationB: Location)
}

public struct BookHistoryCoordinator: BookHistoryCoordinatorProtocol {
    private let nav: UINavigationController
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    public func backToMapVC(locationA: Location, locationB: Location) {
        let mapVC = nav.viewControllers.first as? MapViewController
        mapVC?.changeLocation(locationA: locationA, locationB: locationB)
        nav.popToRootViewController(animated: true)
    }
    
}
