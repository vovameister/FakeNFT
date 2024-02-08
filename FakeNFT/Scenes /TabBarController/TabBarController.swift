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
        let catalogConfiguration = CatalogSceneConfiguration()

        let catalogController = UINavigationController(
            rootViewController: catalogConfiguration.catalogViewController
        )
        
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .yaBackground
    }
}
