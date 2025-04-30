import UIKit

class DailyTableViewCell: UITableViewCell {
    var forecast: Forecast?
    var fiveDaysForcast: FiveDaysForecast?
    
    private lazy var minTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var maxTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var icons: UIImageView = {
        let image = UIImage(systemName: "sun.max.fill")!.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "saturday"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daysLabel, icons, minTemperature, maxTemperature])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DailyTableViewCell {
    private func setUpUI() {
        contentView.addSubview(mainStackView)
        contentView.backgroundColor = .themeColor
        contentView.layer.cornerRadius = 12
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            icons.widthAnchor.constraint(equalToConstant: 25),
            icons.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    func configureDailyTableViewCell(with fiveDayForecast: FiveDaysForecast.List) {
        minTemperature.text = "low: \(Int(fiveDayForecast.main.temp_min))"
        maxTemperature.text = "high: \(Int(fiveDayForecast.main.temp_max))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
        if let date = dateFormatter.date(from: fiveDayForecast.dt_txt) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.locale = Locale(identifier: "en_US_POSIX")
            weekdayFormatter.dateFormat = "EEEE"
            let weekday = weekdayFormatter.string(from: date)
            print(weekday)
            daysLabel.text = weekday.capitalized
        } else {
            daysLabel.text = "-"
        }
    }
}
