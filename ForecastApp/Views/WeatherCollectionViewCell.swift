//
//  WeatherCollectionViewCell.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 7.03.2025.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    private lazy var weatherDesc: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white.withAlphaComponent(0.8)
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return label
        }()
        
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
        
    private lazy var temparature: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.9) // Slight opacity reduction
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    private lazy var highAndLowTemp: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureConstraints()
        configureApperence()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(mainStackView)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    private func configureApperence() {
            contentView.backgroundColor = .themeColor
            contentView.layer.cornerRadius = 18
            contentView.layer.masksToBounds = true
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.1
        }
    func configureLabel(with weatherData: Forecast, temp_Min: Double, temp_Max: Double) {
        cityName.text = weatherData.name
        temparature.text = String(Int(weatherData.main.temp))
        weatherDesc.text = weatherData.weather.first?.description ?? "No description available"
        
        highAndLowTemp.text = "H:\(Int(temp_Max)) L:\(Int(temp_Min))"
    }
}
