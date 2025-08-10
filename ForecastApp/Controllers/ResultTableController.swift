//
//  ResultTableController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.05.2025.
//

import UIKit

protocol ResultTableControllerDelegate: AnyObject {
    func didSelectCity(_ forecast: Forecast)
}

class ResultTableController: UITableViewController {
    private let cellIdentifier = "cityCell"
    var searchResults: [Forecast] = []
    weak var selectionDelegate: ResultTableControllerDelegate?

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

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        searchResults.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResults[indexPath.row]
        print(selectedCity)
        tableView.deselectRow(at: indexPath, animated: true)
        selectionDelegate?.didSelectCity(selectedCity)
    }
}

extension ResultTableController {
    func update(with cities: Forecast) {
        searchResults = [cities]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
