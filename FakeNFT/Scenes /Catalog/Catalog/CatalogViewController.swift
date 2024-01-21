//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 21.01.2024.
//
import UIKit

final class CatalogViewController: UIViewController {
    
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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            style: .default))
        actionSheet.addAction(UIAlertAction(
            title: "По количеству NFT",
            style: .default))
        actionSheet.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel))
        present(actionSheet, animated: true)
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
        return 7 // test
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogTableViewCell = tableView.dequeueReusableCell()
        return cell
    }
}
