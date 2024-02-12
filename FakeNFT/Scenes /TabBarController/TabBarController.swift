import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 0
    )
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )

    private let cartTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(named: "TabCart"),
            tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogConfiguration = CatalogSceneConfiguration()

        let catalogController = UINavigationController(
            rootViewController: catalogConfiguration.catalogViewController
        )
        let profileController = ProfileViewController.shared

        catalogController.tabBarItem = catalogTabBarItem
        profileController.tabBarItem = profileTabBarItem

        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly ?? ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl(),
            usersStorage: UsersStorage()
        ))
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem

        let cartController = CartViewController(presenter: CartViewPresenter(service: CartService(networkClient: DefaultNetworkClient(), storage: CartStorageImpl())))
        cartController.tabBarItem = cartTabBarItem
        

        viewControllers = [profileController, catalogController, statisticsController, cartController]
        selectedIndex = 0
        view.backgroundColor = .background
        view.tintColor = UIColor.segmentActive
    }
    
    func hideTabBar() {
        view.removeFromSuperview()
    }
}
