//
//  WeatherCollectionViewCell.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 7.03.2025.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    private let weatherModel = WeatherModel.mockWeatherData
    
    private lazy var weatherDesc: UILabel = {
        let weatherDesc = UILabel()
        weatherDesc.translatesAutoresizingMaskIntoConstraints = false
        weatherDesc.text = "Sunny"
        weatherDesc.textColor = .white
        return weatherDesc
    }()
    private lazy var cityName: UILabel = {
        let cityName = UILabel()
        cityName.translatesAutoresizingMaskIntoConstraints = false
        cityName.text = "İzmir"
        cityName.font = UIFont.preferredFont(forTextStyle: .title1)
        cityName.textColor = .white
        return cityName
    }()
    private lazy var temparature: UILabel = {
        let temperature = UILabel()
        temperature.text = "12"
        temperature.textColor = .white
        temperature.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        return temperature
    }()
    private lazy var highAndLowTemp: UILabel = {
        let temperature = UILabel()
        temperature.text = "H:34 L:24"
        temperature.textColor = .white
        return temperature
    }()
    private lazy var leftStackView: UIStackView = {
        let leftStackView = UIStackView(arrangedSubviews: [cityName, weatherDesc])
        leftStackView.axis = .vertical
        leftStackView.isLayoutMarginsRelativeArrangement = true // -> stackview içindeki öğelere margin verebilmek için kullanılır.
        leftStackView.distribution = .equalSpacing // -> stackview içerisindeki 2 öğeyi birbirinden zıt köşelere itmek için kullandık. Normalde eşit boşluk verir öğeler arasına.
        leftStackView.alignment = .leading
        leftStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return leftStackView
    }()
    private lazy var rightStackView: UIStackView = {
        let rightStackView = UIStackView(arrangedSubviews: [temparature, highAndLowTemp])
        rightStackView.axis = .vertical
        rightStackView.isLayoutMarginsRelativeArrangement = true
        rightStackView.distribution = .equalSpacing
        rightStackView.alignment = .center
        rightStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 22)
        return rightStackView
    }()
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        mainStackView.axis = .horizontal
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.distribution = .equalSpacing
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 22, bottom: 4, right: 0)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        return mainStackView
    }()
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    private func configureApperence() {
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true // içeriğin köşelerden taşmasını engelledik.
    }
    
    func configure(with weather: WeatherModel) { // MARK: High and low bölümünden verilerin çekilmesine bakılacak. 
        cityName.text = weather.city
        temparature.text = String(weather.temperature)
        weatherDesc.text = weather.tempDescription
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureApperence()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
