import UIKit

final class WeatherHeaderView: UIView {
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let windLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with weather: WeatherData) {
        cityLabel.text = "\(weather.city.name), \(weather.city.country)"
        temperatureLabel.text = "\(Int(weather.current.temperature.rounded()))°"
        windLabel.text = "Wind: \(Int(weather.current.windSpeed.rounded())) km/h"
    }

    private func setup() {
        cityLabel.font = .preferredFont(forTextStyle: .title2)
        cityLabel.numberOfLines = 0
        temperatureLabel.font = .systemFont(ofSize: 52, weight: .bold)
        windLabel.font = .preferredFont(forTextStyle: .body)
        windLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, windLabel])
        stack.axis = .vertical
        stack.spacing = 8

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
