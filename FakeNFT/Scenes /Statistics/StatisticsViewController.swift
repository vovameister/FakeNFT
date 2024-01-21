//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Ramilia on 17/01/24.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        statisticsTableView.reloadData()
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

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsTableCell = statisticsTableView.dequeueReusableCell()
        cell.updateInfo(index: indexPath.row)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
