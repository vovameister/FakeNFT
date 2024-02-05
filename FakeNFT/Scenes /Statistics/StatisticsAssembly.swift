//
//  StatisticsAssembly.swift
//  FakeNFT
//
//  Created by Ramilia on 21/01/24.
//

import UIKit

public final class StatisticsAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let presenter = StatisticsPresenter(
            service: servicesAssembler.statisticsService
        )
        let viewController = StatisticsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}