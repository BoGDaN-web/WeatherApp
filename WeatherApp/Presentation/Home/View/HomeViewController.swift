import UIKit

final class HomeViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {
    private let viewModel: HomeViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let headerView = WeatherHeaderView()
    private let hourlyTitleLabel = UILabel()
    private let dailyTitleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let statusLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let dailyTableView = UITableView(frame: .zero, style: .plain)
    private var weather: WeatherData?

    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 82, height: 88)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier)
        return collectionView
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(viewModel: HomeViewModel())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Weather"
        setupUI()
        bindViewModel()
        Task {
            await viewModel.loadWeather()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather?.hourly.prefix(12).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourlyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? HourlyForecastCell
        else {
            return UICollectionViewCell()
        }

        let items = Array(weather?.hourly.prefix(12) ?? [])
        if indexPath.item < items.count {
            cell.configure(with: items[indexPath.item])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather?.daily.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DailyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? DailyForecastCell,
            let forecast = weather?.daily[indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.configure(with: forecast)
        return cell
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state: state)
        }
        viewModel.onFavoriteChange = { [weak self] isFavorite in
            let imageName = isFavorite ? "star.fill" : "star"
            self?.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    private func render(state: HomeViewModel.State) {
        switch state {
        case .idle:
            break
        case .loading:
            activityIndicator.startAnimating()
            statusLabel.text = "Loading weather..."
        case .loaded(let bundle):
            activityIndicator.stopAnimating()
            statusLabel.text = nil
            weather = bundle
            headerView.configure(with: bundle)
            hourlyCollectionView.reloadData()
            dailyTableView.reloadData()
        case .failed(let message):
            activityIndicator.stopAnimating()
            statusLabel.text = message
        }
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Refresh",
            style: .plain,
            target: self,
            action: #selector(refreshTapped)
        )

        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .systemYellow
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: favoriteButton)

        hourlyTitleLabel.text = "Hourly forecast"
        hourlyTitleLabel.font = .preferredFont(forTextStyle: .headline)
        dailyTitleLabel.text = "7-day forecast"
        dailyTitleLabel.font = .preferredFont(forTextStyle: .headline)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center

        dailyTableView.dataSource = self
        dailyTableView.isScrollEnabled = false
        dailyTableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.reuseIdentifier)

        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourlyCollectionView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.heightAnchor.constraint(equalToConstant: 420).isActive = true

        stackView.axis = .vertical
        stackView.spacing = 20

        [scrollView, activityIndicator].forEach(view.addSubview)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        [headerView, statusLabel, hourlyTitleLabel, hourlyCollectionView, dailyTitleLabel, dailyTableView].forEach {
            stackView.addArrangedSubview($0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

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

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func refreshTapped() {
        Task {
            await viewModel.loadWeather()
        }
    }

    @objc
    private func favoriteTapped() {
        viewModel.toggleFavorite()
    }
}
