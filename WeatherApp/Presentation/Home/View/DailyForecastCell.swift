import UIKit

final class DailyForecastCell: UITableViewCell {
    static let reuseIdentifier = "DailyForecastCell"

    private let dayLabel = UILabel()
    private let temperatureLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with forecast: DailyForecast) {
        dayLabel.text = forecast.date.weatherDayString()
        temperatureLabel.text = "\(Int(forecast.minTemperature.rounded()))° / \(Int(forecast.maxTemperature.rounded()))°"
    }

    private func setup() {
        selectionStyle = .none

        let stack = UIStackView(arrangedSubviews: [dayLabel, UIView(), temperatureLabel])
        stack.axis = .horizontal

        temperatureLabel.textColor = .secondaryLabel

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
}
