import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

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

    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogConfiguration = CatalogSceneConfiguration()

        let catalogController = UINavigationController(
            rootViewController: catalogConfiguration.catalogViewController
        )
        let profileController = ProfileViewController.shared

        catalogController.tabBarItem = catalogTabBarItem
        profileController.tabBarItem = profileTabBarItem

        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly)
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileController, catalogController, statisticsController]
        selectedIndex = 0
        view.backgroundColor = .background
        view.tintColor = UIColor.segmentActive
    }
}
