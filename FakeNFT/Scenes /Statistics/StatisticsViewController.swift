//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Ramilia on 17/01/24.
//

import UIKit

// MARK: - Protocol
protocol StatisticsViewProtocol: AnyObject, ErrorView {
    func displayCells(_ cellModels: [User])
}

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: StatisticsPresenterProtocol
    private var cellModels = [User]()
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "text.justifyleft"), for: .normal)
        button.tintColor = UIColor.segmentActive
        button.addTarget(self, action: #selector(didTapSortingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var statisticsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init

    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        presenter.viewDidLoad()
    }
    
    @IBAction private func didTapSortingButton() {
        //code
    }
    
    private func addViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)
        
        view.addSubview(statisticsTableView)
        
        NSLayoutConstraint.activate([
            statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        statisticsTableView.dataSource = self
        statisticsTableView.delegate = self
        
        view.backgroundColor = .systemBackground
    }
}

// MARK: - StatisticsView Protocol

extension StatisticsViewController: StatisticsViewProtocol {
    func displayCells(_ cellModels: [User]) {
        self.cellModels = cellModels
        statisticsTableView.reloadData()
    }
}

// MARK: - TableView Protocols

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsTableCell = statisticsTableView.dequeueReusableCell()
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}