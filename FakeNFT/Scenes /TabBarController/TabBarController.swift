import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly ?? ServicesAssembly(
                networkClient: DefaultNetworkClient(),
                nftStorage: NftStorageImpl()
            )
        )
        
        let cartTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(named: "TabCart"),
            tag: 1
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(presenter: CartViewPresenter(service: CartService(networkClient: DefaultNetworkClient(), storage: CartStorageImpl())))
        cartController.tabBarItem = cartTabBarItem
        
        viewControllers = [catalogController, cartController]

        view.backgroundColor = .systemBackground
    }
    
    func hideTabBar() {
//        self.tabBar.isHidden = true
//        self.tabBar.isUserInteractionEnabled = false
//        self.viewControllers = []
//        self.reloadInputViews()
//        self.tabBarItem.isEnabled = false
        view.removeFromSuperview()
    }
}
