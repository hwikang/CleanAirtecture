//
//  BookInfoCoordinator.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/6/24.
//

import UIKit

protocol BookInfoCoordinatorProtocol {
    func pushBookHistoryVC()
}

public struct BookInfoCoordinator: BookInfoCoordinatorProtocol {
 
    private let nav: UINavigationController
    init(nav: UINavigationController) {
        self.nav = nav
    }
    func pushBookHistoryVC() {
        let bookRP = BookRepository(bookNetwork: BookNetwork(manager: NetworkManager()), coreData: LocationCoreData())
        let historyUC = BookHistoryUsecase(repository: bookRP)
        let historyVM = BookHistoryViewModel(usecase: historyUC)
        let historyCD = BookHistoryCoordinator(nav: nav)
        let historyVC = BookHistoryViewController(viewModel: historyVM, coordinator: historyCD)
        nav.pushViewController(historyVC, animated: true)
    }
    
}
