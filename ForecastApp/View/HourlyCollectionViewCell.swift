import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    var weatherModel: WeatherModel?
    
    private lazy var hours: UILabel = {
        let label = UILabel()
        label.text = "10AM"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var icons: UIImageView = {
        let image = UIImage(systemName: "sun.max.fill")!.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white.withAlphaComponent(0.9)
        label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .semibold)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hours, icons, temperature])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HourlyCollectionViewCell {
    private func setUpUI() {
        contentView.addSubview(mainStackView)
        contentView.backgroundColor = .themeColor
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            icons.widthAnchor.constraint(equalToConstant: 30),
            icons.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureHourlyCollectionView(with weather: WeatherModel) {
        temperature.text = "\(weather.temperature)"
    }
}
