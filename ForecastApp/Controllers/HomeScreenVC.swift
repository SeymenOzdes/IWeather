//
//  ViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 5.03.2025.
//

import UIKit
import CoreLocation

final class HomeScreenVC: UIViewController {
    
    weak var collectionView: UICollectionView!
    private var searchWorkItem: DispatchWorkItem?
    private var forecast: [Forecast] = []
    private var fiveDaysForecast: [FiveDaysForecast] = []
    private let locationService = LocationService()
    private let networkManager = NetworkManager()
    private let loadingIndicator = LoadingIndicator(frame: .zero)
    private let collectionViewCellIdentifier = "WeatherCell"
    private var resultTableView = ResultTableController()
    
    var searchController: UISearchController!
    
    override func loadView() {
        super.loadView()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        self.collectionView = collectionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBackgroundColor
        self.navigationItem.title = "Weather"
        collectionView.backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        locationService.delegate = self
        
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        locationService.requestLocationPermission()
        setupLoadingIndicator()
        
        setUpSearchBar()
        
        
        // MARK: Search Function Test
       
    }
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func filterOneForecastPerDay(from list: [FiveDaysForecast.List]) -> [FiveDaysForecast.List] {
        var filtered: [FiveDaysForecast.List] = []
        var seenDays: Set<String> = []

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        for forecast in list {
            guard let date = inputFormatter.date(from: forecast.dt_txt) else { continue }
            let dayString = outputFormatter.string(from: date)

            if !seenDays.contains(dayString) {
                filtered.append(forecast)
                seenDays.insert(dayString)
            }
        }

        return filtered
    }
}

extension HomeScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < forecast.count else {
            print("HATA: Geçersiz indexPath.item: \(indexPath.item), weatherModel.count: \(forecast.count)")
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! WeatherCollectionViewCell
        let weather = forecast[indexPath.item]
        cell.configureLabel(with: weather, temp_Min: weather.main.temp_min, temp_Max: weather.main.temp_max)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let forecast = forecast[indexPath.item]
        let fiveDaysForecast = fiveDaysForecast[indexPath.item]
        guard let weatherDetailScreen = WeatherDetailVC(forecast: forecast, fiveDaysForecast: fiveDaysForecast) else { return }
        navigationController?.pushViewController(weatherDetailScreen, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 24, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
}

extension HomeScreenVC: LocationServiceDelegate {
    func locationService(_: LocationService, didUpdateLocation Location: CLLocation) {
        let latitude = Location.coordinate.latitude
        let longitude = Location.coordinate.longitude
        
        loadingIndicator.startAnimating()
        
        Task {
            do {
                let weatherData = try await networkManager.fetchCurrentForecast(latitude: latitude, longitude: longitude)
                let fiveDayForecast = try await networkManager.fetchFiveDayForecast(latitude: latitude, longitude: longitude)

                forecast.append(weatherData)
                
                let filteredList = filterOneForecastPerDay(from: fiveDayForecast.list)
                let filteredFiveDays = FiveDaysForecast(list: filteredList)
                fiveDaysForecast.append(filteredFiveDays)
                
                collectionView.reloadData()
                
            } catch {
                print("error \(error.localizedDescription)")
            }
            
            loadingIndicator.stopAnimating()
        }
    }
    
    func locationService(_: LocationService, didFailWithError: any Error) {
        print("location \(didFailWithError)")
    }
}

extension UIColor {
    static let themeColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    static let mainBackgroundColor = UIColor(red: 240/255, green: 244/255, blue: 250/255, alpha: 1)
}

//MARK: SearchBarDelegate
extension HomeScreenVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: resultTableView)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    func fetchSearchedCities(city: String) async throws -> Forecast {
        let coordinates = try await networkManager.fetchCoordinates(city: city)
        let searchedCity = try await networkManager.fetchCurrentForecast(latitude: coordinates.lat, longitude: coordinates.lon)
        return searchedCity
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            resultTableView.view.isHidden = true
            return
        }
        
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            Task {
                do {
                    guard let cityForecast = try await self?.fetchSearchedCities(city: text) else {return}
                    self?.resultTableView.update(with: cityForecast)
                    print(cityForecast ?? "No city found")
                }
                catch {
                    print("Error fetching city: \(error)")
                }
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}
