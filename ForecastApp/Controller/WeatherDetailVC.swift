//
//  WeatherDetailViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 12.03.2025.
//

import UIKit

class WeatherDetailVC: UIViewController {
    private let weatherModel: WeatherModel
    private var hourlycollectionView: UICollectionView!
    private var dailyTableView: UITableView!
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = weatherModel.city
        label.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
        label.textColor = .white 
        return label
    }()
    
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.text = String(weatherModel.temperature)
        label.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont.systemFont(ofSize: 76, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private lazy var weatherDesciption: UILabel = {
        let label = UILabel()
        label.text = weatherModel.weatherDescription
        label.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: customFont)
        label.textColor = .white.withAlphaComponent(0.8) 
        return label
    }()
    
    private lazy var maxAndLowTemps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H:21° L:10°"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, temperature, weatherDesciption, maxAndLowTemps])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .themeColor
        stackView.layer.cornerRadius = 20 
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(nibName: nil, bundle: nil)
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackgroundColor
        setUpUI()
        configureConstraints()
    }
    private func setUpUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        hourlycollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourlycollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourlycollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCell")
        hourlycollectionView.backgroundColor = .systemBlue
        hourlycollectionView.layer.cornerRadius = 18
        hourlycollectionView.showsHorizontalScrollIndicator = false
        hourlycollectionView?.delegate = self
        hourlycollectionView?.dataSource = self
        
        dailyTableView = UITableView(frame: .zero, style: .plain)
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "DailyCell")
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.separatorColor = .white
        
        view.addSubview(headerStackView)
        view.addSubview(hourlycollectionView!)
        view.addSubview(dailyTableView)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2),
            headerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerStackView.heightAnchor.constraint(equalToConstant: 200),

            hourlycollectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 50),
            hourlycollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hourlycollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hourlycollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            dailyTableView.topAnchor.constraint(equalTo: hourlycollectionView.bottomAnchor, constant: 20),
            dailyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dailyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dailyTableView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension WeatherDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
        cell.configureHourlyCollectionView(with: weatherModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}

extension WeatherDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherModel.city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyTableViewCell else {
            fatalError("Could not dequeue DailyTableViewCell")
        }
        
        cell.configureDailyTableViewCell(with: weatherModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "10-Day Forecast"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.contentView.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
            header.contentView.layer.cornerRadius = 12
        }
    }
}
