import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let sortingStorage = SortingStorage()
        let catalogPresenter = CatalogPresenter(catalogService: catalogService, 
                                                sortingStorage: sortingStorage)
        let catalogController = UINavigationController(
            rootViewController: CatalogViewController(presenter: catalogPresenter)
        )
        
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
}
