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

//        let catalogController = TestCatalogViewController(
//            servicesAssembly: servicesAssembly
//        )
        let catalogController = UINavigationController(rootViewController: CatalogViewController())
        
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
}
