import Foundation

final class HomeViewModel {
    enum State {
        case idle
        case loading
        case loaded(WeatherData)
        case failed(String)
    }

    private let repository: WeatherRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    private(set) var selectedCity: City
    var onStateChange: ((State) -> Void)?
    var onFavoriteChange: ((Bool) -> Void)?

    init(
        repository: WeatherRepositoryProtocol = WeatherRepository(),
        favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository(),
        selectedCity: City = City(id: 625144, name: "Minsk", latitude: 53.9, longitude: 27.5667, country: "Belarus")
    ) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
        self.selectedCity = selectedCity
    }

    func loadWeather() async {
        await MainActor.run {
            self.onStateChange?(.loading)
            self.refreshFavoriteState()
        }

        do {
            let bundle = try await repository.fetchWeather(for: selectedCity)
            await MainActor.run {
                self.onStateChange?(.loaded(bundle))
            }
        } catch {
            await MainActor.run {
                self.onStateChange?(.failed(error.localizedDescription))
            }
        }
    }

    func toggleFavorite() {
        do {
            if try favoritesRepository.isFavorite(city: selectedCity) {
                try favoritesRepository.remove(city: selectedCity)
            } else {
                try favoritesRepository.save(city: selectedCity)
            }
            refreshFavoriteState()
        } catch {
            onStateChange?(.failed(error.localizedDescription))
        }
    }

    private func refreshFavoriteState() {
        let isFavorite = (try? favoritesRepository.isFavorite(city: selectedCity)) ?? false
        onFavoriteChange?(isFavorite)
    }
}
