//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 21.01.2024.
//
import Kingfisher
import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadCatalogTableView()
}

final class CatalogViewController: UIViewController & CatalogViewControllerProtocol {
    // MARK: - Properties
    private var presenter: CatalogPresenterProtocol
    // MARK: - UI-Elements
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            // TODO: Заменить на изображение из макета в следующей итерации:
            image: UIImage(systemName: "text.justifyleft"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))
        button.tintColor = .black
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
        view.backgroundColor = .systemBackground
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
    // MARK: - Actions
    @objc
    private func sortButtonTapped() {
        // TODO: Добавить AlertPresenter
        let actionSheet = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
            title: "По названию",
            style: .default) { _ in
                self.presenter.sortingByName()
            })
        
        actionSheet.addAction(UIAlertAction(
            title: "По количеству NFT",
            style: .default) { _ in
                self.presenter.sortingByNftCount()
            })
        
        actionSheet.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel))
        
        present(actionSheet, animated: true)
    }
}

extension CatalogViewController {
    func reloadCatalogTableView() {
        catalogTableView.reloadData()
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
        // TODO: Обработать выбор ячейки (переход на CollectionViewController)
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
        let collection = presenter.collectionsNft[indexPath.row]
        let collectionCover = URL(string: collection.cover)
        cell.catalogImage.kf.indicatorType = .activity
        cell.catalogImage.kf.setImage(with: collectionCover)
        cell.catalogLabel.text = "\(collection.name) (\(collection.nfts.count))"
        return cell
    }
}
