//
//  LocationDetailViewController.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/3/24.
//

import UIKit

final class LocationDetailViewController: UIViewController {
    private let viewModel: LocationDetailViewModelProtocol
    public init(viewModel: LocationDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
