//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 21.01.2024.
//
import Kingfisher
import UIKit

protocol CatalogViewControllerProtocol: AnyObject, AlertCatalogView {
    func reloadCatalogTableView()
    func showLoadIndicator()
    func hideLoadIndicator()
}

final class CatalogViewController: UIViewController & CatalogViewControllerProtocol {
    // MARK: - Properties
    private var presenter: CatalogPresenterProtocol
    // MARK: - UI-Elements
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "SortButton"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))
        button.tintColor = .segmentActive
        return button
    }()
    
    private lazy var catalogTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.allowsMultipleSelection = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: - Initializers
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.catalogView = self
        presenter.getNtfCollections()
        setupCatalogViewController()
    }
    
    // MARK: - Setup View
    private func setupCatalogViewController() {
        view.backgroundColor = .background
        navigationItem.rightBarButtonItem = sortButton
        view.addSubview(catalogTableView)
        setupTableView()
        setupCatalogViewControllerConstrains()
    }
    
    private func setupTableView() {
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        catalogTableView.register(CatalogTableViewCell.self)
    }
    
    private func setupCatalogViewControllerConstrains() {
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showNFTCollection(indexPath: IndexPath) {
        let configuration = CatalogSceneConfiguration()
        let collection = presenter.collectionsNft[indexPath.row]
        let viewController = configuration.assemblyCollection(collection)
        navigationController?.pushViewController(viewController, animated: true)
    }
    // MARK: - Actions
    @objc
    private func sortButtonTapped() {
        let sortModel = presenter.makeSortingModel()
        self.openAlert(
            title: sortModel.title,
            message: sortModel.message,
            alertStyle: .actionSheet,
            actionTitles: sortModel.actionTitles,
            actionStyles: [.default,
                           .default,
                           .cancel],
            actions: [{ _ in
                self.presenter.sortingByName()
            }, { _ in
                self.presenter.sortingByNftCount()
            }, { _ in }]
        )
    }
}
// MARK: - CatalogViewControllerProtocol
extension CatalogViewController {
    func reloadCatalogTableView() {
        catalogTableView.reloadData()
    }
    
    func showLoadIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}
// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        showNFTCollection(indexPath: indexPath)
    }
    
}
// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.collectionsNft.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogTableViewCell = tableView.dequeueReusableCell()
        let cellModel = presenter.getModel(for: indexPath)
        cell.configCatalogCell(cellModel: cellModel)
        return cell
    }
}
