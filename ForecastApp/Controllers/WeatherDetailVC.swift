//
//  WeatherDetailVC.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 12.03.2025.
//

import UIKit

class WeatherDetailVC: UIViewController {
    private let forecast: Forecast
    private let fiveDaysForecast: FiveDaysForecast
    private var dailyTableView: UITableView!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = forecast.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.text = "\(Int(forecast.main.temp))°"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var weatherDesciption: UILabel = {
        let label = UILabel()
        let description = forecast.weather.first?.description ?? "No description available"
        label.text = description.capitalized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var maxAndLowTemps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H:\(Int(forecast.main.temp_max))° L:\(Int(forecast.main.temp_min))°"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, temperature, weatherDesciption, maxAndLowTemps])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .themeColor
        stackView.layer.cornerRadius = 20
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    init?(forecast: Forecast?, fiveDaysForecast: FiveDaysForecast? = nil) {
        guard let forecast = forecast else {
            return nil
        }
        self.forecast = forecast

        // Eğer fiveDaysForecast nil ise, boş bir liste oluştur
        if let fiveDaysForecast = fiveDaysForecast {
            self.fiveDaysForecast = fiveDaysForecast
        } else {
            // Boş FiveDaysForecast oluştur
            self.fiveDaysForecast = FiveDaysForecast(list: [])
        }

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackgroundColor
        setUpUI()
        configureConstraints()
    }

    private func setUpUI() {
        dailyTableView = UITableView(frame: .zero, style: .plain)
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "DailyCell")
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.separatorColor = .white
        dailyTableView.isScrollEnabled = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerStackView)
        contentView.addSubview(dailyTableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            dailyTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30),
            dailyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dailyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dailyTableView.heightAnchor.constraint(equalToConstant: 350),
            dailyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
}

extension WeatherDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyTableViewCell else {
            fatalError("Could not dequeue DailyTableViewCell")
        }
        let dailyForecast = fiveDaysForecast.list[indexPath.row]
        cell.configureDailyTableViewCell(with: dailyForecast)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        60
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        "5-Day Forecast"
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.contentView.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1)
            header.contentView.layer.cornerRadius = 12
        }
    }
}
