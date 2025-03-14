//
//  WeatherDetailViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 12.03.2025.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    private let weatherModel: WeatherModel

    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = weatherModel.city
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.text = String(weatherModel.temperature)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        return label
    }()
    private lazy var weatherDesciption: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = weatherModel.weatherDescription
        return label
    }()
    private lazy var maxAndLowTemps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H:24 L:10"
        return label
    }()
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, temperature, weatherDesciption, maxAndLowTemps])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        configureConstraints()
        
    }
    private func setUpUI() {
        view.addSubview(headerStackView)
    }
    private func configureConstraints() {
        let headerLabelConstraints = [
            // responsive
            headerStackView.topAnchor.constraint(equalTo:view.topAnchor, constant: view.bounds.height * 0.2),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.4),
        ]
        NSLayoutConstraint.activate(headerLabelConstraints)
    }
}
