//
//  ResultTableViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.05.2025.
//

import UIKit

class ResultTableController: UITableViewController {
    private let cellIdentifier = "cityCell"
    var searchResults: [Forecast] = []
    
    init() {
        super.init(style: .grouped)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    private var cityName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
}

extension ResultTableController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let city = searchResults[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension ResultTableController {
    func update(with cities: Forecast) {
        searchResults.append(cities)
        tableView.reloadData()
    }
}
